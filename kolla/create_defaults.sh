#!/bin/bash

source /opt/stack/venv/kolla/bin/activate
source /etc/kolla/admin-openrc.sh

# Create default project, network and router
openstack project create default-project
openstack network create --project default-project default-network
openstack subnet create --project default-project --network default-network --subnet-range 172.20.0.0/16 default-subnet
openstack router create --project default-project default-router
openstack router set --external-gateway dmz default-router
openstack router add subnet default-router default-subnet

# Create test user in default project
openstack user create --project default-project alces-private-cloud
openstack role add --user alces-private-cloud --project default-project member

# Create default Centos & CirrOS images
openstack image create --file /opt/stack/tools/kolla/images/CentOS-Stream-GenericCloud-8-20220913.0.x86_64.qcow2 --property architecture="x86_64" --disk-format qcow2 --public "CentOS Stream 8 - Generic Cloud"
openstack image create --file /opt/stack/tools/kolla/images/cirros-0.6.1-x86_64-disk.img --property architecture="x86_64" --disk-format qcow2 --public "CirrOS 0.6.1"

# Set quota for default project
openstack quota set --instances 10 --networks 20 --subnets 20 --volumes 20 --key-pairs 20 --ports 100 --floating-ips 10 --ram 51200 --cores 20 --gigabytes 1000 --backup-gigabytes 1000  default-project

# Create default flavors
openstack flavor create --ram 512 --vcpus 1 --disk 10 m1.tiny --public
openstack flavor create --ram 2048 --vcpus 1 --disk 20 m1.small --public
openstack flavor create --ram 4096 --vcpus 2 --disk 40 m1.medium --public
openstack flavor create --ram 8192 --vcpus 4 --disk 80 m1.large --public
openstack flavor create --ram 16384 --vcpus 8 --disk 120 m1.xlarge --public
