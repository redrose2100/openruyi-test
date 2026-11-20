#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   dingjiao
#@Contact   	:   15829797643@163.com
#@Date      	:   2022-07-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Add the macvlan device created on bond to the network namespace verification
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tcpdump
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ping -I "${NODE1_NIC}" baidu.com &
    CHECK_RESULT $? 0 0 "ping -I  ${NODE1_NIC} baidu.com:failed"
    SLEEP_WAIT 3
    timeout 5 tcpdump -i "${NODE1_NIC}" 2>&1 | grep "listening on ${NODE1_NIC}"
    CHECK_RESULT $? 0 0 "tcpdump -i: failed!"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名 kill 所有 ping 进程（等价 pgrep -f ping，ping 的 comm 即 ping）
    proc_kill_pids $(for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = ping ] && echo "${p#/proc/}"; done)
    # openRuyi riscv64 无 pgrep：/proc 遍历按 cmdline 匹配 "tcpdump -i" 并 kill（等价 pgrep "tcpdump -i"；[[ ]] 避免 grep 自匹配）
    proc_kill_pids $(for p in /proc/[0-9]*; do [ -r "$p/cmdline" ] || continue; [ "$BASHPID" = "${p#/proc/}" ] && continue; if [[ "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)" == *'tcpdump -i'* ]]; then echo "${p#/proc/}"; fi; done)
    LOG_INFO "End to restore the test environment."
}

main "$@"
