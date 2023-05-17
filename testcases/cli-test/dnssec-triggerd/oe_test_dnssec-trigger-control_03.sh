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
    dnssec-trigger-control test_ssl
    dnssec-trigger-control status | grep -rn "state: ssl secure" 
    CHECK_RESULT $? 0 0 "Failed to check the test_ssl"
    SLEEP_WAIT 5
    dnssec-trigger-control status | grep -rn "state: ssl secure" 
    CHECK_RESULT $? 0 0 "Failed to check the test_ssl'log"
    dnssec-trigger-control test_tcp
    CHECK_RESULT $? 0 0 "Failed to check the test_tcp"
    SLEEP_WAIT 5
    dnssec-trigger-control status | grep -rn "state: tcp secure"
    CHECK_RESULT $? 0 0 "Failed to check the test_tcp'log"
    dnssec-trigger-control test_http
    CHECK_RESULT $? 0 0 "Failed to check the test_http"
    SLEEP_WAIT 5
    dnssec-trigger-control status | grep -rn "state: nodnssec secure http_insecure"
    CHECK_RESULT $? 0 0 "Failed to check the test_http'log"
    dnssec-trigger-control submit 192.169.5.8
    CHECK_RESULT $? 0 0 "Failed to check the submit status"
    SLEEP_WAIT 5
    dnssec-trigger-control status | grep -rn "192.169.5.8"
    CHECK_RESULT $? 0 0 "Failed to check the submit status'log"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop dnssec-triggerd
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
