#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Add ipv6
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    ipv="fe80:250:250:250:250:250:250:222"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    target_mod="ipv6"
    if ! lsmod | grep "$target_mod"; then
        modinfo -n $target_mod | grep "builtin"
        CHECK_RESULT $? 0 0 "The kernel dosen't have $target_mod mode."
    fi
    ifconfig "${test_nic}" inet6 add ${ipv}/64
    CHECK_RESULT $? 0 0 "Add ipv6 failed."
    ifconfig -a "${test_nic}" | grep ${ipv}
    CHECK_RESULT $? 0 0 "Check ipv6 added failed."
    ip link set "${test_nic}" up
    if ip -6 route show | grep "${test_nic}" | grep default; then
        route=$(ip -6 route show | grep "${test_nic}" | head -n 1 | awk '{print $1}' | cut -d '/' -f 1)
        route -A inet6 add default gw "${route}"1 dev "${test_nic}"
        CHECK_RESULT $? 0 0 "Add route failed."
    fi
    ping6 ${ipv} -c 4
    CHECK_RESULT $? 0 0 "ping ipv6 failed."
    ip link set "${test_nic}" down
    ifconfig -a "${test_nic}" | grep ${ipv}
    CHECK_RESULT $? 1 0 "Check ipv6 removed failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
