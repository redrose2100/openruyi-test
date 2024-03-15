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
#@Desc      	:   Check nic work format
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    test_nic=$(TEST_NIC 1 | awk '{print $1}')
    if mii-tool -v "$test_nic" 2>&1 | grep "Operation not supported"; then
        echo "Operation not supported!"
        exit 0
    fi
    work_mode=$(mii-tool -v "$test_nic" 2>&1 | grep capabilities | cut -d ":" -f 2)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ori_format=$(mii-tool -v "$test_nic" 2>&1 | grep "$test_nic" | cut -d ":" -f 2)
    CHECK_RESULT $? 0 0 "Check original nic work format failed."
    LOG_INFO "The original nic work format of $test_nic is $ori_format"
    find /sys/class/net/"${test_nic}"/device/driver/module
    CHECK_RESULT $? 0 0 "Check directory failed."
    readlink -f /sys/class/net/"${test_nic}"/device/driver/module
    CHECK_RESULT $? 0 0 "Check device failed."
    for mode in ${work_mode}; do
        mii-tool -F "${mode}" "$test_nic"
        CHECK_RESULT $? 0 0 "Change work format to ${mode} failed."
        mii-tool -v "$test_nic" 2>&1 | grep "$test_nic" | grep "${mode}"
        CHECK_RESULT $? 0 0 "Check work format ${mode} changed failed."
    done
    mii-tool -r "$test_nic"
    CHECK_RESULT $? 0 0 "Check up failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
