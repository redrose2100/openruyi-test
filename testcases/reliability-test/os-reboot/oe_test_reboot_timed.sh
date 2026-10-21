#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/06/27
# @License   :   Mulan PSL v2
# @Desc      :   Timed restart
# #############################################

# shellcheck disable=SC1091
source "./common_reboot.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ntp
    DNF_INSTALL ntp 2
    cp -f /etc/ntp.conf /etc/ntp.conf.bak
    echo -e "server ${NODE1_IPV4}\nserver 127.127.1.0\nfudge 127.127.1.0 stratum 8" >>/etc/ntp.conf
    systemctl restart ntpd
    systemctl stop firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    P_SSH_CMD --node 2 --cmd "date -s 01:59:00"
    CHECK_RESULT $? 0 0 "The execution of the 'date -s' command failed."
    P_SSH_CMD --node 2 --cmd "sudo shutdown -r 2:00"
    CHECK_RESULT $? 0 0 "The execution of the 'shutdown -r' command failed."
    SLEEP_WAIT 70
    ping -c 3 "${NODE2_IPV4}"
    CHECK_RESULT $? 0 1 "The execution of the 'ping' command failed."
    REMOTE_REBOOT_WAIT 2 120
    CHECK_RESULT $? 0 0 "The attempt to wait for the startup execution failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    SLEEP_WAIT 10
    P_SSH_CMD --node 2 --cmd "ntpdate ${NODE1_IPV4}"
    systemctl start firewalld
    mv -f /etc/ntp.conf.bak /etc/ntp.conf
    systemctl stop ntpd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
