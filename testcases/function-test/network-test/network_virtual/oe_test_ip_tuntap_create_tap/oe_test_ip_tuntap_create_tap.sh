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
#@Desc      	:   Check ip tuntap
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL net-tools
    route_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1-3).0
    head_ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 1)
    ((head_ip++))
    ip=$(echo "${NODE1_IPV4}" | cut -d '.' -f 2-4)
    new_ip="$head_ip.$ip"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ip help 2>&1 | grep -F "Usage: ip [ OPTIONS ]"
    CHECK_RESULT $? 0 0 "Check ip support tuntap failed."
    ip tuntap help 2>&1 | grep "Usage: ip tuntap"
    CHECK_RESULT $? 0 0 "Check ip tuntap help failed."
    ip tuntap add dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Add ip for tap0 failed."
    ifconfig tap0 "${new_ip}" up
    CHECK_RESULT $? 0 0 "Up tap0 failed."
    route add -host "$route_ip" dev tap0
    CHECK_RESULT $? 0 0 "Add route for tap0 failed."
    route | grep tap0 | grep "$route_ip"
    CHECK_RESULT $? 0 0 "Add route for tap0 failed."
    ip tuntap del dev tap0 mod tap
    CHECK_RESULT $? 0 0 "Delete tap0 failed."
    route | grep tap0 | grep "$route_ip"
    CHECK_RESULT $? 0 1 "Delete tap0 failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
