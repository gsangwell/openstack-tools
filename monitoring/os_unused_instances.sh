#!/bin/bash

THRESHOLD=1209600 # 14 days

seconds2time ()
{
   T=$1
   D=$((T/60/60/24))
   H=$((T/60/60%24))
   M=$((T/60%60))
   S=$((T%60))

   if [[ ${D} != 0 ]]
   then
      printf '%d days %02d:%02d:%02d' $D $H $M $S
   else
      printf '%02d:%02d:%02d' $H $M $S
   fi
}

source /etc/kolla/admin-openrc.sh
source /opt/stack/venv/kolla/bin/activate

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

current_ts=$(date +"%s")

openstack project list --parent default -f value -c ID -c Name | while read line ; do
        uuid=$(echo "$line" | cut -d' ' -f1)
        project=$(echo "$line" | cut -d' ' -f2)

        if [[ "$project" == "admin" ]] ; then continue ; fi
        if [[ "$project" == "service" ]] ; then continue ; fi

	echo "=========== Project: $project ==========="

	i=0

	openstack server list --project $uuid --status SHUTOFF -f value -c ID | while read instanceid ; do

		last_updated=$(openstack server show $instanceid -c updated -f value)
		last_updated=$(date -d "$last_updated" +"%s")
		elapsed=$((current_ts - last_updated))

		if [ "$elapsed" -gt "$THRESHOLD" ] ; then
			echo -e "${RED}Instance $instanceid powered off for $(seconds2time $elapsed)${NC}"
			let "i++"
		fi

	done

	if [ $i -eq 0 ] ; then
		echo -e "${GREEN}None.${NC}"
	fi

	echo ""
done
