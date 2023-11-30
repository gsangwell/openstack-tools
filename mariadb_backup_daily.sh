#!/bin/bash

# Script to run a full mariadb backup using the kolla-ansible playbook
source /root/kolla.sh

echo "Running full mariadb_backup ($(date))"
echo ""

# Clean up backups older than 2 weeks
find /var/lib/docker/volumes/mariadb_backup/_data/ -type f -mtime +14 -name '*.qp.xbc.xbs.gz' -execdir rm -- '{}' \;

# Run kolla-ansible mariadb_backup
kolla-ansible -i /etc/kolla/multinode mariadb_backup

echo ""
