#!/bin/bash

source /etc/kolla/admin-openrc.sh
source /opt/stack/venv/kolla/bin/activate

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

openstack project list --parent default -f value -c ID -c Name | while read line ; do
        uuid=$(echo "$line" | cut -d' ' -f1)
        project=$(echo "$line" | cut -d' ' -f2)

        if [[ "$project" == "admin" ]] ; then continue ; fi
        if [[ "$project" == "service" ]] ; then continue ; fi

	available_volumes=$(openstack volume list --project $uuid --status available -f value | wc -l)

	echo "$project: $available_volumes unused volumes"

done
