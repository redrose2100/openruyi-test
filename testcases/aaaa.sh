#!/bin/bash
while true
do
    ssh 9.82.29.15 '/root/run.sh &>/dev/null'
    ssh 9.82.29.18 '/root/run.sh &>/dev/null'
    let time=10+RANDOM%20
    sleep $time
    ipmitool -I lanplus -H 9.82.30.18 -U Administrator -P 'Huawei12#$' chassis power cycle
    ipmitool -I lanplus -H 9.82.30.15 -U Administrator -P Admin@9000 chassis power cycle
    sleep 120

    count=0
    while true
    do
        ping -c 2 9.82.29.18 && ping -c 2 9.82.29.15 && break
        sleep 10
        ((count=count+1))
        [ $count -gt 30 ] && break
    done
    sleep 10
done