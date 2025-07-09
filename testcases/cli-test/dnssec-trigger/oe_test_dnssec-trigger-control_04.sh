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
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    cp /etc/resolv.conf /etc/resolv.conf.bak
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL dnssec-trigger
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl start dnssec-triggerd
    SLEEP_WAIT 5
    dnssec-trigger-control unsafe
    CHECK_RESULT $? 0 0 "Failed to check the unsafe"
    SLEEP_WAIT 3
    dnssec-trigger-control status |grep "TCP connection failure"
    CHECK_RESULT $? 0 0 "Failed to check the unsafe'log"
    dnssec-trigger-control hotspot_signon
    CHECK_RESULT $? 0 0 "Failed to check the hotspot_signon"
    dnssec-trigger-control status |grep "forced_insecure"
    CHECK_RESULT $? 0 0 "Failed to check the hotspot_signon'log"
    SLEEP_WAIT 3
    dnssec-trigger-control skip_http
    CHECK_RESULT $? 0 0 "Failed to check the skip_http"
    LOG_INFO "Start to run test the dnssec-trigger-control's value reprobe"
    dnssec-trigger-control reprobe
    CHECK_RESULT $? 0 0 "Failed to check the reprobe"
    dnssec-trigger-control  test_tcp -s 127.0.0.1
    CHECK_RESULT $? 0 0 "Failed to check the test_tcp -s"
    dnssec-trigger-control  test_tcp -c ./dnssec-trigger.conf 
    CHECK_RESULT $? 0 0 "Failed to check the test_tcp -c"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop dnssec-triggerd
    DNF_REMOVE "$@"
    mv /etc/resolv.conf.bak /etc/resolv.conf
    LOG_INFO "End to restore the test environment."
}

main "$@"
