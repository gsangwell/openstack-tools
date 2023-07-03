#!/bin/bash

# Generates a letsencrypt cert using the dns challenge method
echo -n "Enter domain: " ; read DOMAIN
echo -n "Enter email: " ; read EMAIL

source /opt/stack/venv/certbot/bin/activate
certbot certonly --manual --preferred-challenges dns --agree-tos --work-dir /opt/stack/certbot/lib --logs-dir /opt/stack/certbot/log --config-dir /opt/stack/certbot/etc --email $EMAIL -d $DOMAIN

date=$(date +"%Y-%m-%d")

# Create combined cert file
cat /opt/stack/certbot/etc/live/${DOMAIN}/fullchain.pem /opt/stack/certbot/etc/live/${DOMAIN}/privkey.pem > /etc/kolla/certificates/haproxy.pem-${date}

# Replace current cert
cp /etc/kolla/certificates/haproxy.pem-${date} /etc/kolla/certificates/haproxy.pem

# Reconfigure HAProxy
source /opt/stack/venv/kolla/bin/activate
kolla-ansible -i /opt/stack/kolla-ansible/multinode reconfigure --tags haproxy
