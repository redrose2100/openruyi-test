#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Desc      :   Test systemd-time-wait-sync.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    P_SSH_CMD --node 2 --cmd "dnf install -y ntp;
    cp /etc/ntp.conf /etc/ntp.conf_bak;
    echo 'server 127.127.1.0 fudge
127.127.1.0 stratum 8' >> /etc/ntp.conf;
    systemctl start ntpd.service;
    systemctl stop firewalld"
    SLEEP_WAIT 360
    DNF_INSTALL systemd-timesyncd
    echo "NTP=${NODE2_IPV4}" >> /etc/systemd/timesyncd.conf
    systemctl start systemd-timesyncd.service
    SLEEP_WAIT 30
    systemctl status systemd-timesyncd.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution systemd-time-wait-sync.service 
    test_reload systemd-time-wait-sync.service 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop systemd-time-wait-sync.service
    systemctl stop systemd-timesyncd.service
    sed -i '/^NTP=/d' /etc/systemd/timesyncd.conf
    DNF_REMOVE "$@"
    P_SSH_CMD --node 2 --cmd "systemctl stop ntpd.service;
    systemctl start firewalld;
    \cp -f /etc/ntp.conf_bak /etc/ntp.conf;
    dnf remove -y ntp"
    LOG_INFO "End to restore the test environment."
}

main "$@"
