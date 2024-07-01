#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test dnssec-trigger-control command 
# #############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dnssec-trigger
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start dnssec-triggerd
    SLEEP_WAIT 5
    dnssec-trigger-control results &
    CHECK_RESULT $? 0 0 "Failed to check the results"
    pgrep -f "dnssec-trigger-control results"
    CHECK_RESULT $? 0 0 "Failed to check the results'process"
    SLEEP_WAIT 5
    dnssec-trigger-control stoppanel
    CHECK_RESULT $? 0 0 "Failed to check the stoppanel"
    SLEEP_WAIT 5
    pgrep -f "dnssec-trigger-control results"
    CHECK_RESULT $? 1 0 "Failed to check the stop dnssec-trigger-control process"
    dnssec-trigger-control status 
    CHECK_RESULT $? 0 0 "Failed to check the status"
    pgrep -f "dnssec-triggerd -d"
    CHECK_RESULT $? 0 0 "Failed to check the status process"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop dnssec-triggerd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
