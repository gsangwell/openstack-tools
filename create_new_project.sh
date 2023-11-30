#!/bin/bash

# Creates a new project with default quotas

if [ -z "$1" ] ; then
        echo -e "\nUsage: $0 [project-name]\n"
        exit 0
fi

PROJECT_NAME=$1

INSTANCES=10
NETWORKS=5
SUBNETS=5
VOLUMES=20
KEYPAIRS=20
PORTS=20
FIPS=10
RAM=51200
CORES=20
DISK=500
BACKUP=500

source /root/kolla.sh

# Check project doesn't exist
if [ $(openstack project show $PROJECT_NAME > /dev/null 2>&1 ; echo $?) -eq 0 ] ; then
	echo "Error - project '$PROJECT_NAME' already exists."
	exit 1
fi

# Create + set default quotas
openstack project create $PROJECT_NAME
openstack quota set --instances $INSTANCES --networks $NETWORKS --subnets $SUBNETS --volumes $VOLUMES --key-pairs $KEYPAIRS --ports $PORTS --floating-ips $FIPS --ram $RAM --cores $CORES --gigabytes $DISK --backup-gigabytes $BACKUP  $PROJECT_NAME
