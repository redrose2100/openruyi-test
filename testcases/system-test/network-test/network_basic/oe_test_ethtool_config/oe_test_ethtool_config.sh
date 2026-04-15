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
#@Desc      	:   Check ping ip
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [ "${NODE1_MACHINE}" = "kvm" ]  || [ $(systemd-detect-virt) = "qemu" ]; then
        ethtool -s "${test_nic}" speed 10
        ethtool "${test_nic}" | grep "Speed: 10Mb/s"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 10 failed."
        ethtool -s "${test_nic}" speed 100
        ethtool "${test_nic}" | grep "Speed: 100Mb/s"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 100 failed."
        ethtool -s "${test_nic}" speed 1000
        ethtool "${test_nic}" | grep "Speed: 1000Mb/s"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: speed 1000 failed."
        ethtool -s "${test_nic}" autoneg off
        ethtool "${test_nic}" | grep "Auto-negotiation: off"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: autoneg off failed."
        ethtool -s "${test_nic}" duplex half
        ethtool "${test_nic}" | grep "Duplex: Half"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: duplex half failed."
        ethtool -s "${test_nic}" duplex full
        ethtool "${test_nic}" | grep "Duplex: Full"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: duplex full failed."
    else
        ethtool -s "${test_nic}" autoneg on
        ethtool "${test_nic}" | grep "Auto-negotiation: on"
        CHECK_RESULT $? 0 0 "Set ${test_nic}: autoneg on failed."
        ethtool -r "${test_nic}"
        ethtool "${test_nic}" | grep "Unknown"
        CHECK_RESULT $? 0 0 "Reset ${test_nic} failed."
    fi
    LOG_INFO "End to run test."
}

main "$@"
