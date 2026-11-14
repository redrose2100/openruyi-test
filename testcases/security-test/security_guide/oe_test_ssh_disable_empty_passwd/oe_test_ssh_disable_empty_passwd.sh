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
# @Modify    :   yang_lijin@qq.com
# @Date      :   2021/5/28
# @License   :   Mulan PSL v2
# @Desc      :   It is not allowed to log in with an account with blank password
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep -q "^testuser:" /etc/passwd && userdel -rf testuser
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # Upstream leaves PermitEmptyPasswords commented out although the default is
    # "no"; make the directive explicit so the assertion below is meaningful.
    sed -i -E 's/^[#[:space:]]*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*PermitEmptyPasswords[[:space:]]+no' /etc/ssh/sshd_config ||
        echo "PermitEmptyPasswords no" >>/etc/ssh/sshd_config
    systemctl restart sshd
    SLEEP_WAIT 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep -qE '^[[:space:]]*PermitEmptyPasswords[[:space:]]+no' /etc/ssh/sshd_config
    CHECK_RESULT $? 0 0 "PermitEmptyPasswords is not no"
    useradd testuser
    CHECK_RESULT $? 0 0 "add testuser failed"
    passwd -d testuser
    # Modern shadow-utils reports an empty password as status "NP" instead of the
    # legacy "Empty password" wording.
    LANG=C passwd -S testuser 2>&1 | grep -qE '(^|[[:space:]])NP([[:space:]]|$)|Empty password|No password'
    CHECK_RESULT $? 0 0 "testuser password is not empty"
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh -o StrictHostKeyChecking=no -o PreferredAuthentications=password testuser@${NODE1_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "password:" {
                send "\\r"
                exp_continue
            }
            eof
        }
EOF
    # An empty password must not allow a login, so ssh keeps asking for one or
    # denies the authentication.
    grep -E "password:|Permission denied" testlog
    CHECK_RESULT $? 0 0 "empty password is accepted by sshd"
    grep -qE "testuser@.*[#$] $" testlog
    CHECK_RESULT $? 0 1 "logged in with an empty password"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    userdel -rf testuser
    rm -f testlog
    if [ -f /etc/ssh/sshd_config-bak ]; then
        mv -f /etc/ssh/sshd_config-bak /etc/ssh/sshd_config
        systemctl restart sshd
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
