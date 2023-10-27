#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangdi
#@Contact   	:   15710801006@163.com
#@Date      	:   2023-10-25
#@License   	:   Mulan PSL v2
#@Desc      	:   Modify config file to change hostname
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    SSH_CMD "mv /etc/sysconfig/network /etc/sysconfig/network.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "mv /etc/hosts /etc/hosts.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    SSH_CMD "hostname test.main" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "echo 'NETWORKING=yes
HOSTNAME=test.main' >> /etc/sysconfig/network" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Write /etc/sysconfig/network config failed."
    SSH_CMD "echo '127.0.0.1 test.main test
    ${NODE2_IPV4} test.main test' >/etc/hosts" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Write /etc/hosts config failed."
    SSH_CMD "uname -n | grep test.main" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Check hostname failed."
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    SSH_CMD "uname -n | grep test.main" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Check hostname failed after reboot."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    SSH_CMD "rm -f /etc/sysconfig/network /etc/hosts" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "mv /etc/sysconfig/network.bak /etc/sysconfig/network" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_CMD "mv /etc/hosts.bak /etc/hosts" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    LOG_INFO "End to restore the test environment."
}

main "$@"
