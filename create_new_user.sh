#!/bin/bash

# Creates a new user associated with a given project

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] ; then
        echo -e "\nUsage: $0 [user-name] [email] [project-name]\n"
        exit 0
fi

USERNAME=$1
EMAIL=$2
PROJECT_NAME=$3

source /root/kolla.sh

# Check user doesn't exist
if [ $(openstack user show $USERNAME > /dev/null 2>&1 ; echo $?) -eq 0 ] ; then
	echo "Error - user '$USERNAME' already exists."
	exit 1
fi

# Check given project exists
if [ $(openstack project show $PROJECT_NAME > /dev/null 2>&1 ; echo $?) -ne 0 ] ; then
	echo "Error - project '$PROJECT_NAME' does not exist."
	exit 1
fi

# Create user
openstack user create --email $EMAIL --project $PROJECT_NAME $USERNAME 

# Add as member to project
openstack role add --user $USERNAME --project $PROJECT_NAME member
