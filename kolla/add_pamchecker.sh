#!/bin/bash

# Update docker file to update upstream container
docker build /opt/stack/tools/kolla/keystone/Dockerfile -t stack-controller:4000/openstack.kolla/centos-source-keystone:yoga
docker push stack-controller:4000/openstack.kolla/centos-source-keystone:yoga
