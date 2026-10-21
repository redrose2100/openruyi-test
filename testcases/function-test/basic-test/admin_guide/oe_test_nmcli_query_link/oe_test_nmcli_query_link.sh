#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020.05-08
# @License   :   Mulan PSL v2
# @Desc      :   Nmcli connection query activation test
# ############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start loading data!"
    interface_num=0
    test_eth=""
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    for interface in /sys/class/net/*; do
        interface_name=$(basename "$interface")
        
        if [[ $interface_name =~ ^(lo|docker|bond|vlan|virbr|br).* ]]; then
            continue
        fi
        
        ((interface_num++))
        test_eth="$interface_name"
        
        if [ "$interface_num" -eq 1 ]; then
            break
        fi
    done
    
    if [ "$interface_num" -ne 1 ]; then
        test_eth=$(ip route | awk -v node_ip="${NODE1_IPV4}" '$0 !~ node_ip { print $3; exit }')
    fi
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    nmcli con add type ethernet ifname "${test_eth}" | grep successfully
    CHECK_RESULT $?
    
    nmcli general status | grep "connected"
    CHECK_RESULT $?
    nmcli connection show | grep "ethernet-${test_eth}"
    CHECK_RESULT $?
    nmcli connection show --active | grep "ethernet"
    CHECK_RESULT $?
    nmcli device status | grep "connected"
    CHECK_RESULT $?
    nmcli connection up id ethernet-"${test_eth}"
    CHECK_RESULT $?
    if [ "$interface_num" -ne 1 ]; then
        nmcli device disconnect "${test_eth}"
        CHECK_RESULT $?
    fi
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    nmcli con delete "$(nmcli con show | grep ethernet- | awk -F " " '{print$1}')"
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup."
}

main "$@"
