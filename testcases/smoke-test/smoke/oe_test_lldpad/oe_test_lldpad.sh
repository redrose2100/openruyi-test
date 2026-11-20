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
# @Date      :   2022/07/12
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of lldpad
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL lldpad
    lldpad_ver=$(rpm -qa lldpad | awk -F '-' '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lldpad -v | grep -iE "$lldpad_ver|Copyright"
    CHECK_RESULT $? 0 0 "Failed to execute lldpad -v"
    lldpad -h 2>&1 | grep "usage:"
    CHECK_RESULT $? 0 0 "Failed to execute lldpad -h"
    lldpad -d
    CHECK_RESULT $? 0 0 "Failed to execute lldpad -d"
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名取 lldpad PID（等价 pgrep lldpad，lldpad 的 comm 即 lldpad）并确认至少一个
    for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = "lldpad" ] && echo "${p#/proc/}"; done | grep -q .
    CHECK_RESULT $? 0 0 "Failed to display lld"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名取 lldpad PID（等价 pgrep lldpad）
    proc_kill_pids $(for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = "lldpad" ] && echo "${p#/proc/}"; done)
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
