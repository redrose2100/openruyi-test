#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/08
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of dbus
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL dbus
    systemctl start dbus
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl status dbus | grep running
    CHECK_RESULT $? 0 0 "Failed to run dbus service"
    # openRuyi riscv64 无 pgrep：按 /proc status 的 Uid 匹配 dbus 用户进程（等价 pgrep -u dbus）
    dbus_uid=$(id -u dbus 2>/dev/null)
    proc_kill_pids $(for p in /proc/[0-9]*; do [ -r "$p/status" ] || continue; [ "$(awk '/^Uid:/{print $2}' "$p/status")" = "$dbus_uid" ] && echo "${p#/proc/}"; done)
    CHECK_RESULT $? 0 0 "Failed to kill the dbus process"
    SLEEP_WAIT 3
    # 同上：检查 dbus 用户进程是否已由服务拉起（等价 pgrep -u dbus）
    for p in /proc/[0-9]*; do [ -r "$p/status" ] || continue; [ "$(awk '/^Uid:/{print $2}' "$p/status")" = "$dbus_uid" ] && echo "${p#/proc/}"; done | grep -q .
    CHECK_RESULT $? 0 0 "Failed to exist dbus service"
    dbus-send --system --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListActivatableNames | grep array
    CHECK_RESULT $? 0 0 "Failed to execute dbus-send"
    systemctl status dbus | grep running
    CHECK_RESULT $? 0 0 "Failed to check dbus service"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
