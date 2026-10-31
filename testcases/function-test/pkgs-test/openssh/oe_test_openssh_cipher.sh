#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Cipher configuration in sshd_config
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    # sshd 的配置与重启都落在 NODE2，避免改坏 NODE1 的 sshd 导致本机失联。
    # 不依赖 sshd_config 中原有一条逐字匹配的 Ciphers 长行（不同发行版默认值不同），
    # 同时兼容"该行存在/被注释/完全不存在"三种情况；sshd -t 校验通过后才重启。
    SSH_CMD "
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
    if grep -q '^#\?[[:space:]]*Ciphers' /etc/ssh/sshd_config; then
        sed -i 's/^#\?[[:space:]]*Ciphers.*/Ciphers aes128-ctr/' /etc/ssh/sshd_config
    else
        echo 'Ciphers aes128-ctr' >> /etc/ssh/sshd_config
    fi
    SSHD=\$(command -v sshd || echo /usr/sbin/sshd)
    \"\$SSHD\" -t || { cp -f /etc/ssh/sshd_config.bak /etc/ssh/sshd_config; systemctl restart sshd; exit 1; }
    systemctl restart sshd
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to restrict Ciphers on NODE2"
    rm -f /root/.ssh/known_hosts
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    expect <<EOF
        log_file /tmp/log_128
        spawn ssh -oCiphers=aes128-ctr ${NODE2_USER}@${NODE2_IPV4} "echo CIPHER_128_OK"
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
    CHECK_RESULT $?
    # 用远程命令的输出标记断言登录成功，不依赖登录横幅里是否带 IP
    grep "CIPHER_128_OK" /tmp/log_128
    CHECK_RESULT $?
    expect <<EOF
        log_file /tmp/log_256
        spawn ssh -oCiphers=aes256-ctr ${NODE2_USER}@${NODE2_IPV4} "echo CIPHER_256_OK"
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
    CHECK_RESULT $? 1 0
    # 服务端已禁用 aes256-ctr，不应拿到远程 shell 的输出
    grep "CIPHER_256_OK" /tmp/log_256
    CHECK_RESULT $? 1 0
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    # 用备份整体回滚，替代易失败的反向 sed
    SSH_CMD "
    mv /etc/ssh/sshd_config.bak /etc/ssh/sshd_config -f
    systemctl restart sshd
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Failed to restore sshd_config on NODE2"
    rm -rf /tmp/log_256 /tmp/log_128 /root/.ssh/known_hosts
    LOG_INFO "End to restore the test environment."
}

main "$@"
