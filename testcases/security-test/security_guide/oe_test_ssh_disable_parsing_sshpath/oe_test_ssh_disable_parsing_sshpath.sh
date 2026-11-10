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
# @CaseName  :   test_ssh_FUN_011
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/6/3
# @License   :   Mulan PSL v2
# @Desc      :   Disable parsing ~/.ssh/environment and ~/.ssh/authorized during SSH login_ Environment variables set in keys
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
# The login user's home directory; ssh-copy-id writes to that user's home,
# which is not necessarily /root.
remote_home=""

function get_remote_home() {
    remote_home=$(eval echo "~${NODE2_USER}")
}

function pre_test() {
    LOG_INFO "Start environmental preparation."
    get_remote_home
    LOG_INFO "Home directory of ${NODE2_USER} on NODE2: ${remote_home}"
    DNF_INSTALL openssh-clients
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
    # Make sure PermitUserEnvironment is explicitly disabled: upstream default is
    # "no", but distributions usually leave the directive commented out.
    sed -i -E 's/^[#[:space:]]*PermitUserEnvironment.*/PermitUserEnvironment no/' /etc/ssh/sshd_config
    grep -qE '^[[:space:]]*PermitUserEnvironment[[:space:]]+no' /etc/ssh/sshd_config ||
        echo "PermitUserEnvironment no" >>/etc/ssh/sshd_config
    systemctl restart sshd
    SLEEP_WAIT 2
    SSH_CMD "rm -rf ${remote_home}/.ssh/environment" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    grep -qE '^[[:space:]]*PermitUserEnvironment[[:space:]]+no' /etc/ssh/sshd_config
    CHECK_RESULT $? 0 0 "PermitUserEnvironment is not disabled"
    SSH_CMD "mkdir -p ${remote_home}/.ssh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "touch ${remote_home}/.ssh/environment" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "chmod 600 ${remote_home}/.ssh/environment" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "echo TESTENV=testenv >>${remote_home}/.ssh/environment" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
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
    find /root/.ssh -maxdepth 1 | grep id_rsa
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
    # Append the environment= option to the authorized_keys of the login user.
    SSH_CMD "sed -i 's|^|environment=\"TESTENV1=testenv1\" |' ${remote_home}/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "cat ${remote_home}/.ssh/authorized_keys | grep 'environment=\"TESTENV1=testenv1\"'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "failed to modify authorized_keys on NODE2"
    rm -f /home/authorized_keys
    SSH_SCP "${NODE2_USER}"@"${NODE2_IPV4}":${remote_home}/.ssh/authorized_keys /home "${NODE2_PASSWORD}"
    grep "environment=\"TESTENV1=testenv1\"" /home/authorized_keys
    CHECK_RESULT $? 0 0 "environment option is not present in authorized_keys"
    # Neither ~/.ssh/environment nor the environment= option may take effect.
    SSH_CMD 'echo "$TESTENV" | grep testenv' "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 1 "TESTENV from ~/.ssh/environment took effect"
    SSH_CMD 'echo "$TESTENV1" | grep testenv1' "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 1 "TESTENV1 from authorized_keys took effect"
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    SSH_CMD "rm -rf ${remote_home}/.ssh/environment ${remote_home}/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf /root/.ssh/id_rsa /root/.ssh/id_rsa.pub /home/authorized_keys
    if [ -f /etc/ssh/sshd_config-bak ]; then
        mv -f /etc/ssh/sshd_config-bak /etc/ssh/sshd_config
        systemctl restart sshd
    fi
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
