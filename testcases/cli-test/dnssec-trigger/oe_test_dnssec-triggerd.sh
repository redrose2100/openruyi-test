#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    systemctl stop unbound
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dnssec-triggerd -h | grep "dnssec-triggerd \[options\]"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -h"
    dnssec-triggerd -v
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -v"
    pgrep -f "dnssec-triggerd -v"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -v process"
    pgrep -f "dnssec-triggerd -v" | xargs kill -9
    SLEEP_WAIT 3
    dnssec-triggerd -d &
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -d"
    pgrep -f "dnssec-triggerd -d"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -d process"
    pgrep -f "dnssec-triggerd -d" | xargs kill -9
    SLEEP_WAIT 3
    dnssec-triggerd -c ./dnssec-trigger.conf
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -c "
    pgrep -f "dnssec-triggerd -c"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -c process"
    pgrep -f "dnssec-triggerd -c" | xargs kill -9
    systemctl start dnssec-triggerd
    SLEEP_WAIT 5
    dnssec-triggerd -u
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -u"
    pgrep -f "dnssec-triggerd -d"
    CHECK_RESULT $? 0 0 "Failed to check the dnssec-triggerd -d process"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf dnssec-triggerd
    LOG_INFO "End to restore the test environment."
}

main "$@"
