#!/bin/bash

# Creates a set of default flavors using the default host aggregrate group
source /root/kolla.sh

openstack flavor create --ram 512 --vcpus 1 --disk 0 m1.tiny --property aggregate_instance_extra_specs:default=true --public
openstack flavor create --ram 2048 --vcpus 1 --disk 0 m1.small --property aggregate_instance_extra_specs:default=true --public
openstack flavor create --ram 4096 --vcpus 2 --disk 0 m1.medium --property aggregate_instance_extra_specs:default=true --public
openstack flavor create --ram 8192 --vcpus 4 --disk 0 m1.large --property aggregate_instance_extra_specs:default=true --public
openstack flavor create --ram 16384 --vcpus 8 --disk 0 m1.xlarge --property aggregate_instance_extra_specs:default=true --public
