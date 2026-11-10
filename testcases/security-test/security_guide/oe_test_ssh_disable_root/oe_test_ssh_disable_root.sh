#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/5/28
# @License   :   Mulan PSL v2
# @Desc      :   Don't allow root account to log in to the system directly using SSH
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    # Upstream ships "#PermitRootLogin prohibit-password", so a plain sed of
    # "PermitRootLogin yes" never matches. Normalize the directive first.
    sed -i -E 's/^[#[:space:]]*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*PermitRootLogin[[:space:]]+no' /etc/ssh/sshd_config ||
        echo "PermitRootLogin no" >>/etc/ssh/sshd_config
    grep -qE '^[[:space:]]*PermitRootLogin[[:space:]]+no' /etc/ssh/sshd_config
    CHECK_RESULT $? 0 0 "PermitRootLogin is not no"
    systemctl restart sshd
    SLEEP_WAIT 2
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh -o StrictHostKeyChecking=no root@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "password:" {
                send "${NODE1_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    grep -E "Permission denied|Login incorrect" testlog
    CHECK_RESULT $? 0 0 "root login is not denied"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/ssh/sshd_config-bak /etc/ssh/sshd_config -f
    systemctl restart sshd
    rm -rf testlog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
