#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-08-12
#@License   	:   Mulan PSL v2
#@Desc      	:   Check nmcli up/down nic
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."

    test_nic=$(TEST_NIC 1)
    config_code=$(test -f /etc/sysconfig/network-scripts/ifcfg-${test_nic})
    if [[ $config_code -eq 1 ]]; then
        cp /etc/sysconfig/network-scripts/ifcfg-${NODE1_NIC} /etc/sysconfig/network-scripts/ifcfg-${test_nic}
        sed -i 's/${NODE1_NIC}/${test_nic}/g' /etc/sysconfig/network-scripts/ifcfg-${test_nic}
        sed -i 's/UUID/#UUID/g' /etc/sysconfig/network-scripts/ifcfg-${test_nic}
    fi 
    systemctl restart NetworkManager
    ori_status=$(ip a | grep -A 1 ${test_nic} | grep "UP")
    systemctl start NetworkManager

    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."

    nmcli con down ${test_nic}
    CHECK_RESULT $? 0 0 "nmcli con down ${test_nic} down failed."
    nmcli con show | grep ${test_nic} | awk '{print $4}' | grep ${test_nic}
    CHECK_RESULT $? 1 0 "Check down failed."
    nmcli con up ${test_nic}
    CHECK_RESULT $? 0 0 "nmcli con up ${test_nic} up failed."
    nmcli con show | grep ${test_nic} | awk '{print $4}' | grep ${test_nic}
    CHECK_RESULT $? 0 0 "Check up failed."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    if [[ $config_code -eq 1 ]]; then
        rm -f /etc/sysconfig/network-scripts/ifcfg-${test_nic}
    fi
    systemctl stop NetworkManager

    LOG_INFO "End to restore the test environment."
}

main "$@"
