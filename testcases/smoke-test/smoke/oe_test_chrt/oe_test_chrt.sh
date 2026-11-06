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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2022/06/20
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of chrt
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    ping -q www.baidu.com &
    SLEEP_WAIT 3
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名取 ping PID（等价 pgrep -f ping，ping 的 comm 即为 ping）
    test_pid=$(for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = ping ] && echo "${p#/proc/}"; done | tail -n 1)
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if ! grep docker /proc/1/cgroup; then
        chrt -f -p 10 "${test_pid}"
        CHECK_RESULT $? 0 0 "Failed to execute chrt"
        chrt -p "${test_pid}" | grep pid
        CHECK_RESULT $? 0 0 "Failed to execute chrt"
        chrt -r -p 10 "${test_pid}"
        CHECK_RESULT $? 0 0 "Failed to execute chrt"
        chrt -p "${test_pid}" | grep pid
        CHECK_RESULT $? 0 0 "Failed to execute chrt"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名 kill 所有 ping 进程（等价 pgrep ping | xargs kill -9）
    for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = ping ] && kill -9 "${p#/proc/}" 2>/dev/null; done
    LOG_INFO "End to restore the test environment."
}

main "$@"
