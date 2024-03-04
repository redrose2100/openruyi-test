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
#@Desc      	:   Change icmp
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    SSH_CMD "cp /etc/sysctl.conf /etc/sysctl.conf.bak" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    SSH_CMD "echo 'net.ipv4.icmp_echo_ignore_all=0' >> /etc/sysctl.conf && sysctl -p" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    CHECK_RESULT $? 0 0 "Change icmp_echo_ignore_all = 0 failed."
    ping -c 5 "${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Ping failed."
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    ping -c 5 "${NODE2_IPV4}"
    CHECK_RESULT $? 0 0 "Ping failed after reboot."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    SSH_CMD "mv /etc/sysctl.conf.bak /etc/sysctl.conf -f" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    REMOTE_REBOOT 2 60
    REMOTE_REBOOT_WAIT 2 60
    LOG_INFO "End to restore the test environment."
}

main "$@"
