#!/bin/bash

source /etc/kolla/admin-openrc.sh
source /opt/stack/venv/kolla/bin/activate

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

print_usage(){
	used=$1
	total=$2

	if [ "$total" -le "-1" ] ; then
		#echo "${YELLOW}used $used of unlimited${NC}"
		echo "${YELLOW}Unlimited (Used $used)${NC}"
	else
		perc=$(echo "($used / $total) * 100" | bc -l |  xargs printf "%.f")

		if [ "$perc" -gt "80" ] ; then
			#echo "${RED}used $used of $total ($perc%)${NC}"
			echo "${RED}${perc}% (used $used of $total)${NC}"
		else
			#echo "${GREEN}used $used of $total ($perc%)${NC}"
			echo "${GREEN}${perc}% (used $used of $total)${NC}"
		fi
	fi
}

openstack project list --parent default -f value -c ID -c Name | while read line ; do
	uuid=$(echo "$line" | cut -d' ' -f1)
	project=$(echo "$line" | cut -d' ' -f2)

	if [[ "$project" == "admin" ]] ; then continue ; fi
	if [[ "$project" == "service" ]] ; then continue ; fi

	# Get quota usage
	compute_usage=$(openstack quota list --detail --compute --project $uuid -f value)
	cinder_usage=$(cinder quota-usage $uuid)
	network_usage=$(openstack quota list --detail --network --project $uuid -f value)

	echo "=========== Project: $project ==========="

	# Compute usage

	instances_total=$(echo "$compute_usage" | grep instances | awk '{print $4}')
	instances_used=$(echo "$compute_usage"  | grep instances | awk '{print $2}') 
	echo -e "Instances: \t $(print_usage $instances_used $instances_total)"

	cores_total=$(echo "$compute_usage" | grep cores | awk '{print $4}')
        cores_used=$(echo "$compute_usage"  | grep cores | awk '{print $2}')
	echo -e "Cores: \t\t $(print_usage $cores_used $cores_total)"

	ram_total=$(echo "$compute_usage" | grep ram | awk '{print $4}')
        ram_used=$(echo "$compute_usage"  | grep ram | awk '{print $2}')
	echo -e "RAM: \t\t $(print_usage $ram_used $ram_total)"

	echo ""

	# Network usage
	fip_total=$(echo "$network_usage" | grep floating_ips | awk '{print $4}')
        fip_used=$(echo "$network_usage" | grep floating_ips | awk '{print $2}')
        echo -e "Floating IPs: \t $(print_usage $fip_used $fip_total)"

	networks_total=$(echo "$network_usage" | grep networks | awk '{print $4}')
	networks_used=$(echo "$network_usage" | grep networks | awk '{print $2}')
	echo -e "Networks: \t $(print_usage $networks_used $networks_total)"

	subnets_total=$(echo "$network_usage" | grep subnets | awk '{print $4}')
        subnets_used=$(echo "$network_usage" | grep subnets | awk '{print $2}')
        echo -e "Subnets: \t $(print_usage $subnets_used $subnets_total)"

	ports_total=$(echo "$network_usage" | grep ports | awk '{print $4}')
        ports_used=$(echo "$network_usage" | grep ports | awk '{print $2}')
        echo -e "Ports: \t\t $(print_usage $ports_used $ports_total)"

	routers_total=$(echo "$network_usage" | grep routers | awk '{print $4}')
        routers_used=$(echo "$network_usage" | grep routers | awk '{print $2}')
        echo -e "Routers: \t $(print_usage $routers_used $routers_total)"

	echo ""

	# Cinder usage
	volumes_total=$(echo "$cinder_usage" | grep " volumes " | awk '{print $8}')
        volumes_used=$(echo "$cinder_usage"  | grep " volumes " | awk '{print $4}')
	echo -e "Volumes: \t $(print_usage $volumes_used $volumes_total)"

	gb_total=$(echo "$cinder_usage" | grep " gigabytes " | awk '{print $8}')
        gb_used=$(echo "$cinder_usage"  | grep " gigabytes " | awk '{print $4}')
	echo -e "Volume GB: \t $(print_usage $gb_used $gb_total)"

	bup_total=$(echo "$cinder_usage" | grep " backups " | awk '{print $8}')
	bup_used=$(echo "$cinder_usage"  | grep " backups " | awk '{print $4}')
	echo -e "Backups: \t $(print_usage $volumes_used $volumes_total)"

	bup_gb_total=$(echo "$cinder_usage" | grep " backup_gigabytes " | awk '{print $8}')
	bup_gb_used=$(echo "$cinder_usage"  | grep " backup_gigabytes " | awk '{print $4}')
	echo -e "Backup GB: \t $(print_usage $gb_used $gb_total)"

	echo ""
done
