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
    DNF_INSTALL "dbus dbus-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dbus-test-tool echo --name=com.example.Echo && pgrep -f "com.example.Echo" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool --name echo failed."
    dbus-test-tool echo --sleep-ms=2 && pgrep -f "sleep-ms" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --sleep-ms failed."
    dbus-test-tool echo --session && pgrep -f "dbus-test-tool echo --session" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --session failed."
    dbus-test-tool echo --system && pgrep -f "dbus-test-tool echo --system" &
    CHECK_RESULT $? 0 0 "Check dbus-test-tool echo --system failed."
    dbus-monitor -h 2>&1 | grep "dbus-monitor"
    CHECK_RESULT $? 0 0 "Check dbus-monitor -h failed."
    dbus-monitor --system "destination=org.fcitx.Fcitx" "sender=org.fcitx.Fcitx" && pgrep -f "dbus-monitor --system" &
    CHECK_RESULT $? 0 0 "Check dbus-monitor --system failed."
    dbus-monitor --profile "destination=org.fcitx.Fcitx" "sender=org.fcitx.Fcitx" 2>&1 | grep "path" &
    CHECK_RESULT $? 0 0 "Check dbus-monitor --profile failed."
    dbus-monitor --monitor "destination=org.fcitx.Fcitx" "sender=org.fcitx.Fcitx" && pgrep -f "dbus-monitor --monitor" &
    CHECK_RESULT $? 0 0 "Check dbus-monitor --monitor failed."
    dbus-monitor --session "destination=org.fcitx.Fcitx" "sender=org.fcitx.Fcitx" && pgrep -f "dbus-monitor --session" &
    CHECK_RESULT $? 0 0 "Check dbus-monitor --session failed."
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
