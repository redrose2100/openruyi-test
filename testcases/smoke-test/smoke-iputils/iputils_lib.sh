#!/bin/bash
hostinfo=`get_host_info_and_vm_name $REMOTE_IP`
hostip=`echo $hostinfo | awk -F "," '{print $1}'`
hostuser=`echo $hostinfo | awk -F "," '{print $2}'`
hostpasswd=`echo $hostinfo | awk -F "," '{print $3}'`
vmname=`echo $hostinfo | awk -F "," '{print $4}'`
eth_main_local=`get_eth_main local`
eth_main_remote=`get_eth_main remote`

function find_unused_ip()
{
    addr=$1
    eth=$2
    local net=`echo $addr | awk -F '.' '{print $1"."$2}'`
    for((i=0;i<30;i++)); do
        arping $addr -c 3 -I $eth > /dev/null
        if [ $? -ne 1 ]; then
            four=`echo $addr | awk -F . '{print $4}'`
            three=`echo $addr | awk -F . '{print $3}'`
            four=`echo $(($four + 1))`
            if [ $four -ge 255 ]; then
                four=0
                three=`echo $(($three + 1))`
            fi
            addr=${net}.$three.$four
        else
            echo $addr
            return 0
        fi
    done
    return 1
}

function ipv6_find_unused_ip()
{
    local addr=$1
    local eth=$2
    local net=`echo $addr | awk -F '::' '{print $1"::"}'`
    for((i=0;i<30;i++)); do
        ip addr add $addr/64 dev $eth
        sleep 2
        success_flag=`ip a | grep $addr | awk '{print $NF}'` > /dev/null
        if [ $success_flag != link ] && [ $success_flag != global ]; then
            ip addr del $addr/64 dev $eth
            local last=$(printf %x $(($RANDOM%252+2)))
            addr=${net}${last}
        else
            echo $addr
            return 0
        fi
    done
    return 1
}
