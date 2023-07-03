#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [node]\n"
}

if [ $# -lt 1 ]
then
        display_usage
        exit 1
fi

host=$1

source /etc/kolla/admin-openrc.sh
source /opt/stack/venv/kolla/bin/activate

state=$(openstack compute service list --service nova-compute --long -f value -c State --host "$host")

if [ -z $state ] ; then
	echo "Invalid nova-compute host ${host}"
	exit
fi

reason=$(openstack compute service list --service nova-compute --long -f value -c "Disabled Reason" --host "$host")
vm_count=$(openstack server list --all-projects --host "$host" --format value -c ID | wc -l)

echo "Host: $host"
echo "State: $state"
echo "Reason: $reason"
echo "Running VMs: $vm_count"
