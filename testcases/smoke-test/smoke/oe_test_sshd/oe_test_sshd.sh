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
# @Date      :   2022/06/15
# @License   :   Mulan PSL v2
# @Desc      :   Test the basic functions of sshd
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    echo >/var/run/sshd.pid
    CHECK_RESULT $? 0 0 "Failed to start sshd"
    systemctl restart sshd
    CHECK_RESULT $? 0 0 "Failed to restart sshd"
    systemctl status sshd | grep running
    CHECK_RESULT $? 0 0 "Failed to check sshd"
    # openRuyi riscv64 无 pgrep：/proc 遍历取 sshd -D 主进程 PID（等价 pgrep -f "sshd -D"；用 bash 内建 [[ ]] 匹配避免 grep 自匹配）
    grep "$(for p in /proc/[0-9]*; do [ -r "$p/cmdline" ] || continue; [ "$BASHPID" = "${p#/proc/}" ] && continue; if [[ "$(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)" == *'sshd -D'* ]]; then echo "${p#/proc/}"; fi; done | head -n 1)" /var/run/sshd.pid
    CHECK_RESULT $? 0 0 "Failed to find pid in /var/run/sshd.pid"
    LOG_INFO "End to run test."
}

main "$@"
