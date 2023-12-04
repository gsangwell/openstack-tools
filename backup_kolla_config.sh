#!/bin/bash

BACKUP_DIR="/opt/service/alces/openstack/kolla"
DATETIME=$(date +'%d-%m-%YT%H%M%S')

if [ -d "${BACKUP_DIR}/${DATETIME}" ] ; then
	echo "Error - backup directory already exists."
	exit 1
fi

mkdir ${BACKUP_DIR}/${DATETIME}

cp -r /etc/kolla/certificates ${BACKUP_DIR}/${DATETIME}/
cp -r /etc/kolla/config ${BACKUP_DIR}/${DATETIME}/
cp /etc/kolla/custom-passwords.yml ${BACKUP_DIR}/${DATETIME}/
cp /etc/kolla/passwords.yml ${BACKUP_DIR}/${DATETIME}/
cp /etc/kolla/globals.yml ${BACKUP_DIR}/${DATETIME}/
cp /etc/kolla/multinode ${BACKUP_DIR}/${DATETIME}/

echo "Config backed up to ${BACKUP_DIR}/${DATETIME}"
ls -lah ${BACKUP_DIR}/${DATETIME}
