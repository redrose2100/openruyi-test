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
    DNF_INSTALL "dbus dbus-tools dbus-x11"
    eval "$(dbus-launch --sh-syntax)"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dbus-send --help 2>&1 | grep "dbus-send"
    CHECK_RESULT $? 0 0 "Check dbus-send --help failed."
    dbus-send --session --type=method_call --print-reply --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames | grep "string"
    CHECK_RESULT $? 0 0 "Check dbus-send --session --type failed."
    dbus-send --session --type=method_call --print-reply=literal --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames | grep "org.freedesktop.DBus"
    CHECK_RESULT $? 0 0 "Check dbus-send --session --type=method_call --print-reply=literal --dest failed."
    dbus-send --session --type=method_call --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames
    CHECK_RESULT $? 0 0 "Check dbus-send --session --type=method_call --dest failed."
    dbus-send --system --type=method_call --print-reply=literal --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames
    CHECK_RESULT $? 0 0 "Check dbus-send --system --type=method_call --print-reply=literal --dest=org.freedesktop.DBus failed."
    dbus-send --system --type=method_call --print-reply=literal --reply-timeout=1 --dest=org.freedesktop.DBus / org.freedesktop.DBus.ListNames
    CHECK_RESULT $? 0 0 "Check dbus-send --system --type=method_call --print-reply=literal --reply-timeout=1 --dest=org.freedesktop.DBus failed."
    dbus-update-activation-environment -h 2>&1 | grep "dbus-update-activation-environment"
    CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment -h failed."
    dbus-update-activation-environment --all
    CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --all failed."
    dbus-update-activation-environment --systemd
    CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --systemd failed."
    dbus-update-activation-environment --all --verbose 2>&1 | grep "setting"
    CHECK_RESULT $? 0 0 "Check dbus-update-activation-environment --all --verbose failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    pgrep "dbus" |xargs kill -9
    systemctl stop dbus
    LOG_INFO "End to restore the test environment."
}
main "$@"
