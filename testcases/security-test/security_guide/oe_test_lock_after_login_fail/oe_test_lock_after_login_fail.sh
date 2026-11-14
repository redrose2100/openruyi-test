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
# @modify    :   yang_lijin@qq.com
# @Date      :   2021/05/11
# @License   :   Mulan PSL v2
# @Desc      :   Allow public key authentication
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    grep "^test:" /etc/passwd && userdel -rf test
    ls testlog && rm -rf testlog
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # 注释态（#PubkeyAuthentication yes）不等于关闭，实际默认值就是 yes。
    # 原脚本直接 grep 显式配置行，在未显式写出该指令的发行版上必然失败。
    if ! grep -qE '^[[:space:]]*PubkeyAuthentication[[:space:]]+yes' /etc/ssh/sshd_config; then
        sed -i -E 's/^[#[:space:]]*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
        grep -qE '^[[:space:]]*PubkeyAuthentication[[:space:]]+yes' /etc/ssh/sshd_config ||
            echo 'PubkeyAuthentication yes' >>/etc/ssh/sshd_config
        systemctl restart sshd
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep -qE '^[[:space:]]*PubkeyAuthentication[[:space:]]+yes' /etc/ssh/sshd_config
    CHECK_RESULT $? 0 0 "grep 'PubkeyAuthentication yes' failed"
    expect <<EOF
	set timeout 15
        spawn ssh-keygen -t rsa
        expect {
            "save the key" {
                send "\\r"
            }
        }
        expect {
            "Enter passphrase" {
                send "\\r"
            }
        }
        expect {
            "Enter same passphrase again" {
                send "\\r"
            }
        }
        expect {
            "*Enter file in which to save the key*"{
                send "\\r"
            }
        }
        expect {
            "*y/n*" {
                send "y\\r"
            }
        }
        expect eof
EOF
    ls -l /root/.ssh/*id_rsa*
    CHECK_RESULT $? 0 0 "grep id_rsa failed"
    expect <<EOF
        set timeout 15
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${NODE2_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "*password*" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    # ssh-copy-id 把公钥写进目标用户自己的 ~/.ssh/authorized_keys，不是 /root 下。
    SSH_CMD "grep ssh-rsa \$(eval echo ~${NODE2_USER})/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "grep ssh-rsa in ${NODE2_USER} authorized_keys failed"
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh "${NODE2_USER}"@"${NODE2_IPV4}"
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "*password*" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    SLEEP_WAIT 1
    # 原脚本用 grep '[root@]'（字符类）几乎恒为真，改成匹配真实登录提示符。
    grep -E "${NODE2_USER}@" testlog
    CHECK_RESULT $? 0 0 "login failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/ssh/sshd_config-bak /etc/ssh/sshd_config -f
    systemctl restart sshd
    SSH_CMD "rm -f \$(eval echo ~${NODE2_USER})/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf /root/.ssh/id_rsa /root/.ssh/id_rsa.pub testlog
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
