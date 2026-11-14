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
# @Date      :   2020/6/4
# @License   :   Mulan PSL v2
# @Desc      :   Disable SSH agent forwarding
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
# ssh-copy-id writes authorized_keys into the home directory of the login user,
# which is not necessarily /root.
remote_home2=""
remote_home3=""

function pre_test() {
    LOG_INFO "Start environmental preparation."
    remote_home2=$(eval echo "~${NODE2_USER}")
    remote_home3=$(eval echo "~${NODE3_USER}")
    LOG_INFO "Home directory of ${NODE2_USER}: ${remote_home2}, of ${NODE3_USER}: ${remote_home3}"
    cp -f /etc/ssh/ssh_config /etc/ssh/ssh_config-bak
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # Upstream leaves AllowAgentForwarding commented out although the default is
    # "no"; make it explicit so that the assertion below is meaningful.
    sed -i -E 's/^[#[:space:]]*AllowAgentForwarding.*/AllowAgentForwarding no/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*AllowAgentForwarding[[:space:]]+no' /etc/ssh/sshd_config ||
        echo "AllowAgentForwarding no" >>/etc/ssh/sshd_config
    systemctl restart sshd
    SLEEP_WAIT 2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep -qE '^[[:space:]]*AllowAgentForwarding[[:space:]]+no' /etc/ssh/sshd_config
    CHECK_RESULT $? 0 0 "AllowAgentForwarding is not no"
    expect <<EOF
        set timeout 15
        spawn ssh-keygen -t rsa -f /root/.ssh/id_rsa
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
    CHECK_RESULT $? 0 0 "id_rsa is not generated"
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
    expect <<EOF
        set timeout 15
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub ${NODE3_USER}@${NODE3_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect {
            "password" {
                send "${NODE3_PASSWORD}\\r"
            }
        }
        expect eof
EOF
    rm -f /home/authorized_keys
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":${remote_home2}/.ssh/authorized_keys /home "${NODE2_PASSWORD}"
    grep ssh-rsa /home/authorized_keys
    CHECK_RESULT $? 0 0 "NODE2 grep ssh-rsa failed"
    rm -rf /home/authorized_keys
    SSH_SCP "${NODE3_USER}"@"${NODE3_IPV4}":${remote_home3}/.ssh/authorized_keys /home "${NODE3_PASSWORD}"
    grep ssh-rsa /home/authorized_keys
    CHECK_RESULT $? 0 0 "NODE3 grep ssh-rsa failed"
    eval "$(ssh-agent)"
    ssh-add /root/.ssh/id_rsa
    sed -i -E 's/^[#[:space:]]*ForwardAgent.*/ForwardAgent yes/' /etc/ssh/ssh_config
    grep -qE '^[[:space:]]*ForwardAgent[[:space:]]+yes' /etc/ssh/ssh_config ||
        echo "ForwardAgent yes" >>/etc/ssh/ssh_config
    grep -qE '^[[:space:]]*ForwardAgent[[:space:]]+yes' /etc/ssh/ssh_config
    CHECK_RESULT $? 0 0 "ForwardAgent is not yes"
    SSH_CMD "touch /home/test.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "rm -f /home/test.txt" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    # scp between two remote hosts runs on the local side, so the local ssh client
    # forwards the agent and must not be asked for a password.
    expect <<EOF
        set timeout 30
        log_file testlog
        spawn scp -R ${NODE2_USER}@${NODE2_IPV4}:/home/test.txt ${NODE3_USER}@${NODE3_IPV4}:/home
        expect {
            "*yes/no*" {
                send "yes\\r"
                exp_continue
            }
            "password:" {
                send "${NODE3_PASSWORD}\\r"
                exp_continue
            }
            eof
        }
EOF
    SSH_CMD "ls -l /home/test.txt" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    CHECK_RESULT $? 0 0 "copy test.txt to NODE3 with agent forwarding disabled failed"
    SSH_CMD "sed -i -E 's/^[#[:space:]]*AllowAgentForwarding.*/AllowAgentForwarding yes/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*AllowAgentForwarding[[:space:]]+yes' /etc/ssh/sshd_config || echo 'AllowAgentForwarding yes' >>/etc/ssh/sshd_config
    systemctl restart sshd" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SLEEP_WAIT 2
    SSH_CMD "rm -f /home/test.txt" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${NODE2_USER}"@"${NODE2_IPV4}":/home/test.txt "${NODE3_USER}"@"${NODE3_IPV4}":/home
    CHECK_RESULT $? 0 0 "scp failed"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    mv /etc/ssh/ssh_config-bak /etc/ssh/ssh_config -f
    mv /etc/ssh/sshd_config-bak /etc/ssh/sshd_config -f
    systemctl restart sshd
    proc_kill_pids $(proc_pids_by_cmdline ssh-agent)
    SSH_CMD "rm -rf ${remote_home2}/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "rm -rf ${remote_home3}/.ssh/authorized_keys" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    SSH_CMD "rm -rf /home/test.txt" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "rm -rf /home/test.txt" "${NODE3_IPV4}" "${NODE3_PASSWORD}" "${NODE3_USER}"
    rm -rf /root/.ssh/id_rsa /root/.ssh/id_rsa.pub testlog /home/authorized_keys
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
