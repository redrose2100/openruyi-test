#!/usr/bin/bash
case "$1" in
start)
    echo "reparing for Real Server"
    echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
    dnf -y install httpd net-tools 
    systemctl start httpd
    systemctl stop firewalld
    lsmod | grep ipip || modprobe ipip
    ip addr add dev tunl0 ipvs_vip/24
    route add -host ipvs_vip dev tunl0
    sleep 5
    sysctl -a | grep rp_filter
    sleep 5
    sysctl -w net.ipv4.conf.all.rp_filter=0
    sysctl -w net.ipv4.conf.default.rp_filter=0
    sysctl -w net.ipv4.conf.eth_use.rp_filter=0
    sysctl -w net.ipv4.conf.tunl0.rp_filter=0
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
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
    echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
    route del -host ipvs_vip dev tunl0
    ip addr del  dev tunl0 ipvs_vip/24
    sleep 5
    sysctl -a | grep rp_filter
    sleep 10
    sysctl -w net.ipv4.conf.all.rp_filter=1
    sysctl -w net.ipv4.conf.default.rp_filter=1
    sysctl -w net.ipv4.conf.eth_use.rp_filter=1
    sysctl -w net.ipv4.conf.tunl0.rp_filter=1
    sleep 2
    modprobe -r ipip
    rm -rf /var/www/html/index.html /tmp/LVS_TUN_RIP_config.sh
    dnf -y remove httpd remove net-tools
    systemctl start firewalld
    systemctl stop httpd
    ;;
*)
    echo "Usage: LVS_DR_RIP_config.sh {start|stop}"
    exit 1
    ;;
esac
