#!/bin/bash

# remove_nova.sh [hostname]
# Removes a nova host from the cloud

source /root/kolla.sh

if [ -z "$1" ] ; then
	echo -e "\nUsage: $0 [hostname]\n"
	exit 0
fi

# Hostname
HOST=$1

# Check host is a valid host
if [ $(openstack hypervisor show $HOST > /dev/null 2>&1; echo $?) -ne 0 ] ; then
	echo -e "Error: unknown nova host '${HOST}'"
	exit 1
fi

# Confirm
echo "Removing nova host '${HOST}'"
read -p "Are you sure? (y/n) " -n 1 -r ; echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
	echo -e "Cancelled."
	exit 0
fi

# Check no vms are currently running on the host
if [ $(openstack server list --all-projects --host ${HOST} -f value -c ID | wc -l) -ne 0 ] ; then
	echo -e "Error: please migrate instances from the nova host first."
	exit 1
fi

# Disable the compute service
echo "Disabling compute service.."
openstack compute service set ${HOST} nova-compute --disable

# Cleanup network agents
echo "Removing network agents.."
openstack network agent list --host ${HOST} -f value -c ID | while read id; do
  openstack network agent delete $id
done

# Cleanup compute service
echo "Removing compute services.."
openstack compute service list --os-compute-api-version 2.53 --host ${HOST} -f value -c ID | while read id; do
  openstack compute service delete --os-compute-api-version 2.53 $id
done

echo ""
echo "Removed nova host '${HOST}'."
echo "Ensure to remove the host from /etc/kolla/multinode if not redeploying."
echo ""
