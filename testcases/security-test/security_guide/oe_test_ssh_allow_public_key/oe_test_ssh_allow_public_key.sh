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

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # 上游默认 sshd_config 里 PubkeyAuthentication 是注释状态
    # （#PubkeyAuthentication yes），注释不等于关闭，实际默认值就是 yes。
    # 原脚本直接 grep 一个显式配置行，在未显式写出该指令的发行版上必然失败。
    # 这里在没有显式配置时补一行，让断言检查“确实允许公钥认证”这件事实。
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
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    # ssh-copy-id 把公钥追加到“目标用户自己”的 ~/.ssh/authorized_keys，
    # 而不是 root 的 /root/.ssh/authorized_keys。原脚本按 root 家目录取文件，
    # 必然 No such file。这里让远端 shell 展开该用户家目录，不写死路径。
    SSH_CMD "grep ssh-rsa \$(eval echo ~${NODE2_USER})/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "grep ssh-rsa in ${NODE2_USER} authorized_keys failed"
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh ${NODE2_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE2_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    SLEEP_WAIT 1
    # 原脚本用 grep '[root@]'（字符类，任意一个 r/o/t/@ 都算命中），
    # 几乎不会因为登录失败而失败，等于没校验。改成匹配真实登录后的提示符。
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
