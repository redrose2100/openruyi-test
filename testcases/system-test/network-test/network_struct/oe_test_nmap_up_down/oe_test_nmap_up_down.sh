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
#@Desc      	:   Check nmcli up/down nic
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    if ! find /etc/sysconfig/network-scripts -maxdepth 1 -type f | read; then
        LOG_WARN "There are no files under /etc/sysconfig/network-scripts, skip."
        exit 255
    fi
    if [ ! -f /etc/sysconfig/network-scripts/ifcfg-"${test_nic}" ]; then
        cp /etc/sysconfig/network-scripts/ifcfg-"${NODE1_NIC}" /etc/sysconfig/network-scripts/ifcfg-"${test_nic}"
        sed -i "s/${NODE1_NIC}/${test_nic}/g" /etc/sysconfig/network-scripts/ifcfg-"${test_nic}"
        sed -i 's/UUID/#UUID/g' /etc/sysconfig/network-scripts/ifcfg-"${test_nic}"
        flag=1
    fi 
    systemctl restart NetworkManager
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nmcli c up "${test_nic}"
    CHECK_RESULT $? 0 0 "Up ${test_nic} failed."
    nmcli c show | grep "${test_nic}" | awk '{print $4}' | grep "${test_nic}"
    CHECK_RESULT $? 0 0 "Check ${test_nic} up failed."
    nmcli c down "${test_nic}"
    CHECK_RESULT $? 0 0 "Down ${test_nic} failed."
    nmcli c show | grep "${test_nic}" | awk '{print $4}' | grep "${test_nic}"
    CHECK_RESULT $? 1 0 "Check ${test_nic} down failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ $flag -eq 1 ]; then
        rm -rf /etc/sysconfig/network-scripts/ifcfg-"${test_nic}"
    fi
    systemctl restart NetworkManager
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
