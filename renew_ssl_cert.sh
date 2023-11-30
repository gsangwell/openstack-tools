#!/bin/bash

# Generates a letsencrypt cert using the dns challenge method
echo -n "Enter domain: " ; read DOMAIN
echo -n "Enter email: " ; read EMAIL

source /opt/venv/certbot/bin/activate
certbot certonly --manual --preferred-challenges dns --agree-tos --email $EMAIL -d $DOMAIN

if [ $? -ne 0 ] ; then
	echo "Error - certificate failed to renew."
	exit 1
fi

date=$(date +"%Y-%m-%d")

cat /etc/letsencrypt/live/${DOMAIN}/fullchain.pem /etc/letsencrypt/live/${DOMAIN}/privkey.pem > /etc/kolla/certificates/haproxy.pem-${date}

# Replace current cert
cp /etc/kolla/certificates/haproxy.pem-${date} /etc/kolla/certificates/haproxy.pem

# Reconfigure haproxy?
echo "Certificate renewed - HAProxy will need to be reconfigured."
echo "Note: This will cause an temporary service outage."
read -p "Reconfigure HAProxy now? (y/n) " -n 1 -r ; echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
        echo "HAProxy not reconfigured."
	echo "In order to deploy the new certification, please run:"
	echo ""
	echo "source /root/kolla.sh"
	echo "kolla-ansible -i /etc/kolla/multinode reconfigure --tags haproxy"
	echo ""
        exit 0
fi

echo "Reconfiguring HAProxy.."

# Now actually reconfigure HAProxy
source /root/kolla.sh
kolla-ansible -i /etc/kolla/multinode reconfigure --tags haproxy
echo ""
