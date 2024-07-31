#!/bin/bash
# Copyright (c), 2022-2022, Huawei Tech. Co., Ltd.
# Description: elfutils lib
# Author: tianyuan <tianyuan8@huawei.com>
# Create: 2022-01-17
# History:

source "$OET_PATH"/libs/lib.sh &> /dev/null
source ../../package_lib.sh
set +e

function check_log_info() {
    local check_file=$1
    shift
    local check_list=("$@")
    for info in "${check_list[@]}"; do
        grep -w "$info" "$check_file"
        CHECK_RESULT $? 0 0
    done
}

function check_help_info() {
    if ! grep 'eu-elfclassify' tmp_help.log; then
        grep -iE 'warn|fail' tmp_help.log
        CHECK_RESULT $? 1 0
    fi
    diff tmp_help.log tmp_help.log1
    CHECK_RESULT $? 0 0
}

function check_version_info() {
    local test_cmd="$1"
    elfutils_ver=$(rpm -q elfutils | awk -F'-' '{print $2}')
    # shellcheck disable=SC2046
    $test_cmd -V &> tmp_version.log
    grep "^$test_cmd (elfutils) ${elfutils_ver}$" tmp_version.log
    CHECK_RESULT $? 0 0
    grep -i 'Usage:' tmp_version.log
    CHECK_RESULT $? 1 0
    grep -iE 'err|fail|warn' tmp_version.log
    CHECK_RESULT $? 1 0
    # shellcheck disable=SC2046
    $test_cmd --version &> tmp_version.log1
    CHECK_RESULT $? 0 0
    diff tmp_version.log tmp_version.log1
    CHECK_RESULT $? 0 0
}

function get_own_resource() {
    resource_type=$1
    which systemctl > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        localip=$(ifconfig -a | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk '{print $2}')
    else
        localip=$(ifconfig -a | grep "inet addr" | grep -v "127.0.0.1" | cut -d: -f2 | awk '{print $1}')
    fi
    if [ ! -f "$OET_PATH"/conf/MultiNode.conf ]; then
        echo "can't find multi-node configuration at $OET_PATH/conf"
        return 1
    fi
    for ip in $localip; do
        if cat "$OET_PATH"/conf/MultiNode.conf | grep "$ip" &> /dev/null; then
            for data in $(cat "$OET_PATH"/conf/MultiNode.conf | grep "$ip" | sed 's/,/ /g'); do
                key=$(echo "$data" | awk -F '=' '{print$1}')
                if [ "$key" = "$resource_type" ]; then
                    value=$(echo "$data" | awk -F '=' '{print$2}')
                    break
                fi
            done
        fi
        if [ "$value" != "" ]; then
            break
        fi
    done
    echo "$value"
    if [ "$value" = "" ]; then
        return 1
    fi
}

function get_resource_by_nodeID() {
    nodeID=$1
    resource_type=$2

    if cat "$OET_PATH"/conf/MultiNode.conf | grep "NodeID=$nodeID" &> /dev/null; then
        for data in $(cat "$OET_PATH"/conf/MultiNode.conf | grep "NodeID=$nodeID" | sed 's/,/ /g'); do
            key=$(echo "$data" | awk -F '=' '{print$1}')
            if [ "$key" = "$resource_type" ]; then
                value=$(echo "$data" | awk -F '=' '{print$2}')
                break
            fi
        done
    else
        echo "Not find nodeID $nodeID, please check"
        return 1
    fi
    echo "$value"
    if [ "$value" = "" ]; then
        return 1
    fi
}

function get_own_node_id() {
    node_id=$(get_own_resource NodeID)
    echo "$node_id"
    if [ "$node_id" = "" ]; then
        return 1
    fi
}

function get_own_manage_ip() {
    manage_ip=$(get_own_resource manage_ip)
    echo "$manage_ip"
    if [ "$manage_ip" = "" ]; then
        return 1
    fi
}

function get_own_cpu_type() {
    cpu_type=$(get_own_resource cpu)
    echo "$cpu_type"
    if [ "$cpu_type" = "" ]; then
        return 1
    fi
}

function get_own_total_mem() {
    total_mem=$(get_own_resource total_mem)
    echo "$total_mem"
    if [ "$total_mem" = "" ]; then
        return 1
    fi
}

function get_own_manage_ipv6() {
    manage_ipv6=$(get_own_resource manage_ipv6)
    echo "$manage_ipv6"
    if [ "${manage_ipv6}" = "" ]; then
        return 1
    fi
}

function get_own_service_ip() {
    service_ip=$(get_own_resource service_ip)
    echo "${service_ip}"
    if [ "${service_ip}" = "" ]; then
        return 1
    fi
}

function get_manage_ip_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    manage_ip=$(get_resource_by_nodeID "$nodeID" manage_ip)
    echo "$manage_ip"
    if [ "${manage_ip}" = "" ]; then
        return 1
    fi
}

function get_manage_username_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    manage_username=$(get_resource_by_nodeID "$nodeID" manage_username)
    echo "$manage_username"
    if [ "${manage_username}" = "" ]; then
        return 1
    fi
}

function get_manage_password_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    manage_password=$(get_resource_by_nodeID "$nodeID" manage_password)
    echo "$manage_password"
    if [ "${manage_password}" = "" ]; then
        return 1
    fi
}

function get_cpu_type_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    cpu=$(get_resource_by_nodeID "$nodeID" cpu)
    echo "$cpu"
    if [ "$cpu" = "" ]; then
        return 1
    fi
}

function get_total_mem_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    mem=$(get_resource_by_nodeID "$nodeID" total_mem)
    echo "$mem"
    if [ "$mem" = "" ]; then
        return 1
    fi
}

function get_manage_ipv6_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    manage_ipv6=$(get_resource_by_nodeID "$nodeID" manage_ipv6)
    echo "$manage_ipv6"
    if [ "${manage_ipv6}" = "" ]; then
        return 1
    fi
}

function get_service_ip_by_nodeid() {
    nodeID=$1
    if [ "$nodeID" = "" ]; then
        echo "node id must be input"
        return 1
    fi
    service_ip=$(get_resource_by_nodeID "$nodeID" service_ip)
    echo "${service_ip}"
    if [ "${service_ip}" = "" ]; then
        return 1
    fi
}

function get_own_available_network_card() {
    card_type=$1
    if [ "$card_type" = "" ]; then
        echo "Network card type must be input, you can input 'default' if you don not know"
        return 1
    fi
    which systemctl > /dev/null 2>&1
    if [ "$?" = "0" ]; then
        localip=$(ifconfig -a | grep inet | grep -v inet6 | grep -v "127.0.0.1" | awk '{print $2}')
    else
        localip=$(ifconfig -a | grep "inet addr" | grep -v "127.0.0.1" | cut -d: -f2 | awk '{print $1}')
    fi
    if [ ! -f "$OET_PATH"/conf/MultiNode.conf ]; then
        echo "can't find multi-node configuration at $OET_PATH/conf"
        return 1
    fi
    for ip in $localip; do
        if cat "$OET_PATH"/conf/MultiNode.conf | grep "$ip" &> /dev/null; then
            for data in $(cat "$OET_PATH"/conf/MultiNode.conf | grep "$ip" | sed 's/,/ /g'); do
                if [ "$card_type" != "default" ]; then
                    value=$(echo "$data" | awk -F '=' '{print$2}')
                    if echo "$value" | grep -wi "$card_type" &> /dev/null; then
                        key=$(echo "$data" | awk -F '=' '{print$1}')
                        if ! ifconfig "$key" | grep "netmask" &> /dev/null; then
                            break
                        else
                            key=""
                        fi
                    fi
                else
                    key=$(echo "$data" | awk -F '=' '{print$1}')
                    if ifconfig "$key" &> /dev/null; then
                        if ! ifconfig "$key" | grep "netmask" &> /dev/null; then
                            break
                        else
                            key=""
                        fi
                    fi
                fi
            done
            break
        fi
    done
    echo $key
    if [ "$key" = "" ]; then
        return 1
    fi
}

function get_available_network_card_by_nodeid() {
    card_type=$1
    node_id=$2
    if [ "$card_type" = "" ]; then
        echo "Network card type must be input, you can input 'default' if you don't know"
        return 1
    fi

    if [ "$node_id" = "" ]; then
        echo "node id must be input"
        return 1
    fi

    ip=$(get_manage_ip_by_nodeid "$node_id")
    username=$(get_manage_username_by_nodeid "$node_id")
    passwd=$(get_manage_password_by_nodeid "$node_id")

    if cat "$OET_PATH"/conf/MultiNode.conf | grep "${node_id}" &> /dev/null; then

        for data in $(cat "$OET_PATH"/conf/MultiNode.conf | grep "${node_id}" | sed "s/,/ /g"); do
            if [ "$card_type" != "default" ]; then
                value=$(echo "$data" | awk -F '=' '{print$2}')
                if echo "$value" | grep -wi "$card_type" &> /dev/null; then
                    key=$(echo "$data" | awk -F '=' '{print$1}')
                    OET_SSHCMD "ifconfig $key | grep netmask &>/dev/null" "$username" "$passwd" "$ip" &> /dev/null
                    if [ "$?" != "0" ]; then
                        break
                    else
                        key=""
                    fi
                fi
            else

                key=$(echo "$data" | awk -F '=' '{print$1}')
                if OET_SSHCMD "ifconfig $key" "$username" "$passwd" "$ip" &> /dev/null; then
                    OET_SSHCMD "ifconfig $key | grep netmask &>/dev/null" "$username" "$passwd" "$ip" &> /dev/null
                    if [ "$?" != "0" ]; then
                        break
                    else
                        key=""
                    fi
                fi
            fi
        done
    fi

    echo $key
    if [ "$key" = "" ]; then
        return 1
    fi
}


