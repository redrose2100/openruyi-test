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
# @Author    :   wangxiaoya
# @Contact   :   wangxiaoya@qq.com
# @Date      :   2022/6/10
# @License   :   Mulan PSL v2
# @Desc      :   Su permission restriction - enable reinforcement by default
# ############################################


source "$OET_PATH/libs/locallibs/common_lib.sh"
# A dedicated test password long enough to satisfy pam_pwquality.
TEST_PASSWORD="Oetest1@Sec23"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep -q "^test1:" /etc/passwd && userdel -rf test1
    grep -q "^test2:" /etc/passwd && userdel -rf test2
    useradd test1
    useradd test2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect <<EOF
        set timeout 30
        spawn passwd test1
        expect {
            "*assword*" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    expect <<EOF
        set timeout 30
        spawn passwd test2
        expect {
            "*assword*" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    usermod -a -G wheel test1
    # openRuyi 适配：原写法在 "*test2@*" 分支里 exp_continue，shell 提示符本身
    # （[test2@host dir]$）每次都会再次匹配该模式，于是无限 send pwd，用例直到
    # 1800s 超时（本次报告日志里产生了近 200 万行 pwd 输出）。
    # 改为顺序式交互：等密码提示 -> 等登录后提示符 -> 执行 pwd -> exit -> eof。
    expect <<EOF
        set timeout 30
        log_file testlog1
        spawn su test2
        expect "*assword*"
        send "${TEST_PASSWORD}\\r"
        expect "*test2@*"
        send "pwd\\r"
        expect "*test2@*"
        send "exit\\r"
        expect eof
EOF
    grep "test2@" testlog1
    CHECK_RESULT $? 0 0 "switch to test2 failed"
    expect <<EOF
        set timeout 30
        log_file testlog2
        spawn su test1
        expect "*assword*"
        send "${TEST_PASSWORD}\\r"
        expect "*test1@*"
        send "su test2\\r"
        expect "*test2@*"
        send "exit\\r"
        expect "*test1@*"
        send "exit\\r"
        expect eof
EOF
    grep "test2@" testlog2
    CHECK_RESULT $? 0 0 "switch from test1 to test2 failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -f testlog1 testlog2
    userdel -rf test1
    userdel -rf test2
}

main "$@"
