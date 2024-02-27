#!/bin/bash
#
# config_tap          Start up the tun/tap virtual nic
#
# chkconfig: 2345 55 25

head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
((head_ip++))
ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
NEW_IP="$head_ip.$ip"

TAP_DEV_NUM=0
DESC="TAP config"

start() {
    if [ ! -x /usr/sbin/tunctl ]; then
        echo "/usr/sbin/tunctl was NOT found!"
        exit 1
    fi
    tunctl -t tap$TAP_DEV_NUM -u root
    ifconfig tap$TAP_DEV_NUM "${NEW_IP}" netmask 255.255.255.0 promisc
    ifconfig tap$TAP_DEV_NUM
}

stop() {
    ifconfig tap$TAP_DEV_NUM down
}
restart() {
    stop
    start
}
check_status() {
    ifconfig tap$TAP_DEV_NUM
}

case $1 in
    start)
        start && exit 0
        ;;
    stop)
        stop
        ;;
    restart)
        restart && exit 0
        ;;
    status)
        echo "Status of $DESC: "
        check_status && exit 0
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
exit $?
