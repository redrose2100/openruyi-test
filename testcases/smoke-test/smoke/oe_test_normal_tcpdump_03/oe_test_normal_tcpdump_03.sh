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
# @Date      :   2022/07/15
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of tcpdump
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL tcpdump
    ping -q -I "${NODE1_NIC}" baidu.com &
    SLEEP_WAIT 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # `tcpdump -c 10` 只在抓到 10 个包后才退出。网卡基本空闲时永远等不到，
    # 管道不会收到 EOF；而且“listening on”是 tcpdump 写到 stderr 的，直接
    # 2>&1 给 grep 会把真正的错误（如无权限）也吞掉。改为先把输出落到文件，
    # 用 timeout 限制时长，失败时能把 tcpdump 的原文打印进日志。
    local cap_log=/tmp/tcpdump_cap.log
    timeout 20 tcpdump -i "${NODE1_NIC}" -c 10 -w test.pcap >"${cap_log}" 2>&1
    grep "listening on ${NODE1_NIC}" "${cap_log}"
    CHECK_RESULT $? 0 0 "Failed to execute tcpdump -w: $(tr '\n' ' ' < "${cap_log}")"
    test -s ./test.pcap
    CHECK_RESULT $? 0 0 "Failed to find test.pcap: $(tr '\n' ' ' < "${cap_log}")"
    tcpdump -r test.pcap 2>&1 | grep "reading from file test.pcap"
    CHECK_RESULT $? 0 0 "Failed to execute tcpdump -r"
    tcpdump -r test.pcap | grep -E "IP|ARP"
    CHECK_RESULT $? 0 0 "Failed to display IP"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # openRuyi riscv64 无 pgrep：/proc 遍历按进程名取 ping PID（等价 pgrep ping）
    proc_kill_pids $(for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = "ping" ] && echo "${p#/proc/}"; done)
    rm -rf ./test.pcap /tmp/tcpdump_cap.log
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
