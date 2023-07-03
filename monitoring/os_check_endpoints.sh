#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

source /opt/stack/venv/kolla/bin/activate
source /etc/kolla/admin-openrc.sh 

openstack endpoint list --interface public -c 'Service Name' -c 'URL' -f value | while read line ; do
	endpoint=$(echo $line | cut -d' ' -f1)
	url=$(echo $line | cut -d' ' -f2)
	
	# Check endpoint
	curl -s "$url" > /dev/null 2>&1
	ec=$?

	if [ $ec -eq 0 ]; then
		echo -e "${endpoint} - ${GREEN}OK${NC}"
	else
		echo -e "${endpoint} - ${RED}Error${NC}"
	fi
done
