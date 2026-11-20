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
# @Date      :   2020/05/27
# @License   :   Mulan PSL v2
# @Desc      :   Verify warnings for default network remote login
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

BANNER_TEXT="Authorized users only. All activities may be monitored and reported."

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL openssh-clients
    cp -f /etc/issue.net /etc/issue.net-bak 2>/dev/null
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # Ship the standard login warning and make sshd display it. The banner text is
    # site specific, so the case prepares it instead of assuming a preinstalled one.
    echo "${BANNER_TEXT}" >/etc/issue.net
    sed -i -E 's/^[#[:space:]]*Banner.*/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*Banner[[:space:]]+/etc/issue\.net' /etc/ssh/sshd_config ||
        echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
    systemctl restart sshd
    SLEEP_WAIT 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep "${BANNER_TEXT}" /etc/issue.net
    CHECK_RESULT $? 0 0 "${BANNER_TEXT} is not configured in /etc/issue.net"
    expect <<EOF1
        log_file log
        set timeout 15
        spawn ssh -o StrictHostKeyChecking=no ${NODE1_USER}@127.0.0.1
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "assword:" {
                send "${NODE1_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF1
    grep "${BANNER_TEXT}" log
    CHECK_RESULT $? 0 0 "the login warning is not displayed before authentication"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f log
    if [ -f /etc/issue.net-bak ]; then
        mv -f /etc/issue.net-bak /etc/issue.net
    else
        rm -f /etc/issue.net
    fi
    if [ -f /etc/ssh/sshd_config-bak ]; then
        mv -f /etc/ssh/sshd_config-bak /etc/ssh/sshd_config
        systemctl restart sshd
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
