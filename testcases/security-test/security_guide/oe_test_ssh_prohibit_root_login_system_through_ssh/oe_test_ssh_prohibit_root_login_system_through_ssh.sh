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
# @Desc      :   Prohibit the root account from directly SSH logging into the system - reinforcement is not enabled by default
# ############################################


source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openssh-clients
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    expect <<EOF
        set timeout 30
        log_file testlog1
        spawn ssh -o StrictHostKeyChecking=no root@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "*assword*" {
                send "${NODE2_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    # Root must not be allowed to log in remotely: sshd answers with
    # "Permission denied" and never hands out a root shell.
    grep -E "Permission denied|Login incorrect|Too many authentication failures" testlog1
    CHECK_RESULT $? 0 0 "root login through ssh was not denied"
    grep -E "^root@.*[#$] $" testlog1
    CHECK_RESULT $? 0 1 "root logged in through ssh"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -rf testlog*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
