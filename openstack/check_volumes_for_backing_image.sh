#!/bin/bash

display_usage() {
  echo -e "\nUsage: $0 [imageid]\n"
}

if [ $# -lt 1 ]
then
        display_usage
        exit 1
fi

targetid=$1

image_name=$(openstack image show $targetid -c name -f value)

if [ -z "$image_name" ] ; then
	exit
fi

openstack volume list --all-projects -c ID -f value | while read volumeid ; do
	imageid=$(openstack volume show $volumeid -c volume_image_metadata -f json | jq --raw-output .volume_image_metadata.image_id)

	if [[ "$imageid" == "$targetid" ]] ; then
		echo "Volume ${volumeid}"
	fi
done
