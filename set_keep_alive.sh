#!/bin/bash
if [ $UID != 0 ]; then
	echo "ERROR: Not root user?"
	exit 1
fi
echo "Setting custom keepalive parameters:"
echo "net.ipv4.tcp_keepalive_time = 60" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 10" >> /etc/sysctl.conf
echo ""
