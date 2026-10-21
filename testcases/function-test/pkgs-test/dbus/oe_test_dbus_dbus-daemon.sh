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
    vers=$(rpm -qa | grep dbus-daemon | awk -F - '{print $3}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dbus-daemon -h 2>&1 | grep "dbus-daemon"
    CHECK_RESULT $? 0 0 "Check dbus-daemon -h failed."
    dbus-daemon --version | grep "${vers}"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --version failed."
    dbus-daemon --session &
    pgrep -f "dbus-daemon --session"
    CHECK_RESULT $? 0 0 "Check bus-daemon --session failed."
    dbus-daemon --session --fork
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork failed."
    dbus-daemon --session --fork --print-address | grep -E "abstract=|path="
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --print-address failed."
    dbus-daemon --session --fork --print-pid | grep "^[0-9]"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --print-pid failed."
    dbus-daemon --session --fork --introspect | grep "!DOCTYPE"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --introspect failed."
    dbus-daemon --session --nofork &
    pgrep -f "dbus-daemon --session --nofork"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --nofork failed."
    pgrep "dbus" |xargs kill -9
    dbus-daemon --session --fork --address=unix:abstract=/tmp/dbus-123456 --print-address | grep "/tmp/dbus-123456"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --address=unix:abstract=/tmp/dbus-123456 --print-address failed."
    dbus-daemon --session --fork --nopidfile &
    SLEEP_WAIT 1
    pgrep -f "dbus-daemon --session --fork --nopidfile"
    CHECK_RESULT $? 0 0 "Check dbus-daemon --session --fork --nopidfile failed."
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
