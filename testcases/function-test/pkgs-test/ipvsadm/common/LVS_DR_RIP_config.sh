#!/usr/bin/bash

case "$1" in
start)
    echo "reparing for Real Server"
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
    dnf -y install httpd
    systemctl start httpd
    systemctl stop firewalld
    ip addr add ipvs_vip/32 dev lo
    server1=serveripvs_ip
    echo "$server1" >/var/www/html/index.html
    check_http=$(curl localhost)
    if [ "${check_http}" == $server1 ]; then
        echo "RS server1 environment is ready."
    else
        echo "RS server1 curl localhost is  error."
    fi
    ;;
stop)
    ip addr del ipvs_vip/32 dev lo
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
    rm -rf /var/www/html/index.html /tmp/LVS_DR_RIP_config.sh
    dnf -y remove httpd
    systemctl start firewalld
    systemctl stop httpd
    ;;
*)
    echo "Usage: LVS_DR_RIP_config.sh {start|stop}"
    exit 1
    ;;
esac
