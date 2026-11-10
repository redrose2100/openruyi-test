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
# @Desc      :   Only allow RSA for security authentication
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
    CHECK_RESULT $? 0 0 "id_rsa file is not exist"
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
    # ssh-copy-id installs the key into the home directory of the login user,
    # not necessarily /root.
    local remote_keys
    remote_keys="$(eval echo ~${NODE2_USER})/.ssh/authorized_keys"
    SSH_CMD "grep ssh-rsa ${remote_keys}" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "NODE2 grep ssh-rsa ${remote_keys} failed"
    expect <<EOF
        set timeout 15
        log_file testlog
        spawn ssh ${NODE2_USER}@${NODE2_IPV4}
        expect {
            "*yes/no*" {
                send "yes\\r"
            }
        }
        expect eof
EOF
    grep -E "Last login:|${NODE2_USER}@" testlog
    CHECK_RESULT $? 0 0 "ssh log failed"
    SSH_CMD "rm -rf ${remote_keys}" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    # DSA key based authentication has been removed from OpenSSH (disabled by
    # default since 9.8, unsupported since 10.0), so the DSA half of this case
    # cannot be executed on current platforms and is intentionally skipped.
    LOG_INFO "DSA key authentication is no longer supported by OpenSSH, skip that part."
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    SSH_CMD "rm -rf $(eval echo ~${NODE2_USER})/.ssh/authorized_keys" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    rm -rf /root/.ssh/id_rsa* testlog1 testlog /root/.ssh/id_dsa*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
