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
#@Desc      	:   Check ip link set nic
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ip link set "${test_nic}" down
    CHECK_RESULT $? 0 0 " ip link set ${test_nic} down failed."
    ip a | grep -A 1 "${test_nic}" | grep "UP"
    CHECK_RESULT $? 1 0 "Check down failed."
    ip link set "${test_nic}" up
    CHECK_RESULT $? 0 0 " ip link set ${test_nic} up failed."
    ip a | grep -A 1 "${test_nic}" | grep "UP"
    CHECK_RESULT $? 0 0 "Check up failed."
    LOG_INFO "End to run test."
}

main "$@"
