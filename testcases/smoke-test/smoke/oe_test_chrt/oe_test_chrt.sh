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
    if ! grep -q docker /proc/1/cgroup 2>/dev/null; then
        # 设置实时调度策略需要 CAP_SYS_NICE。原逻辑只靠 /proc/1/cgroup 判断容器，
        # 判不出“非容器但能力受限”的环境（openRuyi 上 chrt 直接报
        # "failed to set pid N's policy: Operation not permitted"），
        # 于是断言必然失败。这里先探测能力，不具备则跳过实时策略部分。
        if [ -z "${test_pid}" ]; then
            LOG_WARN "No ping process found, skip chrt priority checks."
            LOG_INFO "End to run test."
            return 0
        fi
        if ! chrt -f -p 10 "${test_pid}" 2>&1 | tee /tmp/chrt_probe.log | grep -v "Operation not permitted" >/dev/null; then
            LOG_WARN "Setting real-time scheduling policy is not permitted, skip chrt priority checks."
            LOG_INFO "End to run test."
            return 0
        fi
        if grep -q "Operation not permitted" /tmp/chrt_probe.log; then
            LOG_WARN "No CAP_SYS_NICE, skip chrt priority checks."
            LOG_INFO "End to run test."
            return 0
        fi
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
    rm -f /tmp/chrt_probe.log
    LOG_INFO "End to restore the test environment."
}

main "$@"
