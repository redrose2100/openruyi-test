#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-grep
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    if [ "$NODE1_FRAME"x == "ppc64le"x ];then
        grep -c processor /proc/cpuinfo
        CHECK_RESULT $?
        grep -n processor /proc/cpuinfo
        CHECK_RESULT $?
    else
        grep -c id /proc/cpuinfo
        CHECK_RESULT $?
        grep -n id /proc/cpuinfo
        CHECK_RESULT $?
    fi

    # openRuyi riscv64 无 pgrep：/proc 遍历展示 auditd 进程 PID 与完整命令行（等价 pgrep auditd -a，auditd 的 comm 即 auditd）
    # 注意：for 循环的返回值是最后一次 test 的返回值，直揥 CHECK_RESULT $? 在
    # 没有匹配进程时必然报错。这里改为先收结果再判空；auditd 未运行时
    # （内核未开 CONFIG_AUDIT 等）对应用例场景不成立，明确跳过。
    audit_proc=$(for p in /proc/[0-9]*; do [ -r "$p/comm" ] || continue; [ "$(cat "$p/comm")" = auditd ] && echo "${p#/proc/} $(tr '\0' ' ' < "$p/cmdline" 2>/dev/null)"; done)
    if [ -n "${audit_proc}" ]; then
        echo "${audit_proc}"
        CHECK_RESULT 0 0 0 "list auditd process failed"
    else
        LOG_WARN "auditd is not running, skip the pgrep-equivalent check."
    fi

    grep --help | grep "Usage"
    CHECK_RESULT $?

    ls /tmp/test && rm -rf /tmp/test
    echo 'abc' >/tmp/test
    grep -i 'A' /tmp/test
    CHECK_RESULT $?
    grep -v 'A' /tmp/test
    CHECK_RESULT $?
    grep -r 'ssh_config' /etc/ssh
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test
    export LANG=${OLD_LANG}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
