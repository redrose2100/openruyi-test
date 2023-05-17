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
    dnssec-trigger-control -h | grep "dnssec-trigger-control \[options\] command"
    CHECK_RESULT $? 0 0 "Failed to check the -h"
    systemctl start dnssec-triggerd
    CHECK_RESULT $? 0 0 "Failed to check the start"
    systemctl status dnssec-triggerd | grep -i "active (running)"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-trigger status"
    SLEEP_WAIT 5
    dnssec-trigger-control results  &
    ps -ef|grep "dnssec-trigger-control results"|grep -v grep
    CHECK_RESULT $? 0 0 "Failed to check the results"
    SLEEP_WAIT 15
    dnssec-trigger-control stop
    CHECK_RESULT $? 0 0 "Failed to check the stop"
    ps -ef|grep "dnssec-trigger-control results"|grep -v grep
    CHECK_RESULT $? 1 0 "Failed to check the stop dnssec-trigger-control process"
    systemctl stop dnssec-triggerd
    SLEEP_WAIT 5
    systemctl start dnssec-triggerd
    SLEEP_WAIT 5
    dnssec-trigger-control cmdtray &
    ps -ef|grep "dnssec-trigger-control cmdtray"|grep -v grep
    CHECK_RESULT $? 0 0 "Failed to check the cmdtray"
    SLEEP_WAIT 15
    ps -ef|grep cmdtray|grep -v grep|awk {'print $2'}|xargs kill -9
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop dnssec-triggerd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
