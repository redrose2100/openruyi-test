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
# @Date      :   2022/6/17
# @License   :   Mulan PSL v2
# @Desc      :   Password validity - reinforcement is not enabled by default
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
    grep -q "^PASS_MAX_DAYS[[:space:]]\+99999" /etc/login.defs
    CHECK_RESULT $? 0 0 "The password is not valid for 99999."
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
    expect <<EOF
        set timeout 30
        log_file testlog1
        spawn su test2
        expect {
            "*assword*" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            "*test2@*" {
                send "exit\\r"
                exp_continue
            }
            eof
        }
EOF
    grep "test2@" testlog1
    CHECK_RESULT $? 0 0 "login failed!"
    SLEEP_WAIT 180
    expect <<EOF
        set timeout 30
        log_file testlog2
        spawn su test2
        expect {
            "*assword*" {
                send "${TEST_PASSWORD}\\r"
                exp_continue
            }
            "*test2@*" {
                send "exit\\r"
                exp_continue
            }
            eof
        }
EOF
    grep "test2@" testlog2
    CHECK_RESULT $? 0 0 "login failed!"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -f testlog1 testlog2
    userdel -rf test1
    userdel -rf test2
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
