#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   wangshan
# @Contact   :   wangshan@163.com
# @Date      :   2023-07-15
# @License   :   Mulan PSL v2
# @Desc      :   exrmultipart exrheader exrenvmap
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dbus"
    vers=$(rpm -qa | grep "dbus-daemon" | awk -F - '{print $3}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dbus-run-session --help 2>&1 | grep "dbus-run-session"
    CHECK_RESULT $? 0 0 "Check dbus-run-session --help failed."
    dbus-run-session --version | grep "${vers}"
    CHECK_RESULT $? 0 0 "Check dbus-run-session --version failed."
    dbus-cleanup-sockets --help 2>&1 | grep "dbus-cleanup-sockets"
    CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets --help failed."
    dbus-cleanup-sockets --version | grep "${vers}"
    CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets --version failed."
    dbus-cleanup-sockets /tmp
    CHECK_RESULT $? 0 0 "Check dbus-cleanup-sockets /tmp failed."
    dbus-test-tool black-hole --session && pgrep -f "dbus-test-tool black-hole --session" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --session failed."
    dbus-test-tool black-hole --system && pgrep -f "dbus-test-tool black-hole --system" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --system failed."
    dbus-test-tool black-hole --name=com.example.NoReply && pgrep -f "com.example.NoReply" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --name=com.example.NoReply failed."
    dbus-test-tool black-hole --no-read && pgrep -f "--no-read" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool black-hole --no-read failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pgrep "dbus" |xargs kill -9
    systemctl stop dbus
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
