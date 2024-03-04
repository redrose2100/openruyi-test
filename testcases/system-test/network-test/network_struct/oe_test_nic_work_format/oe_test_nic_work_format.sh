#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL net-tools
    test_nic=$(TEST_NIC 1)
    work_format=('1000baseT-FD' '100baseTx-FD' '100baseTx-HD' '10baseT-FD' '10baseT-HD')
    num=('1000' '100' '100' '10' '10')
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    ori_format=$(mii-tool -v "$test_nic" | grep "$test_nic" | cut -d ":" -f 2)
    CHECK_RESULT $? 0 0 "Check original nic work format failed."
    LOG_INFO "The original nic work format of $test_nic is $ori_format"
    ls -l /sys/class/net/"${test_nic}"/device/driver/module
    CHECK_RESULT $? 0 0 "Check directory failed."
    readlink -f /sys/class/net/"${test_nic}"/device/driver/module
    CHECK_RESULT $? 0 0 "Check device failed."
    for i in $(seq 0 $((${#work_format[@]} - 1))); do
        mii-tool -F "${work_format[$i]}" "$test_nic"
        CHECK_RESULT $? 0 0 "Change work format to ${work_format[$i]} failed."
        mii-tool -v "$test_nic" | grep "${num[$i]}"
        CHECK_RESULT $? 0 0 "Check work format ${work_format[$i]} changed failed."
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
