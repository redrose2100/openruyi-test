#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-15
# @License   :   Mulan PSL v2
# @Desc      :   nss-mdns mDNS hostname resolution test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL nss-mdns
    cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
    
    # Step 1: Configure nsswitch.conf for mdns
    if ! grep -E '^hosts:' /etc/nsswitch.conf | grep -q mdns; then
        sed -i 's/^hosts: \(.*\)/hosts: mdns4_minimal \[NOTFOUND=return\] \1/' /etc/nsswitch.conf
    fi
    
    # Step 2: Backup original hostname, Set a valid hostname for mDNS testing
    ORIG_HOSTNAME=$(hostname)
    NEW_HOSTNAME="test-mdns-host"
    hostnamectl set-hostname "$NEW_HOSTNAME"
    
    # Step 3: Start avahi-daemon service
    systemctl start avahi-daemon
    SLEEP_WAIT 3
    
    # Step 4: Verify avahi-daemon is running
    if ! systemctl is-active avahi-daemon; then
        LOG_INFO "avahi-daemon failed to start. mDNS resolution requires avahi-daemon. Skipping test."
        exit 1
    fi
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 5: Get short hostname with .local suffix
    short_hostname=$(hostname -s).local
	CHECK_RESULT $? 0 0 "Failed to get short hostname"

    # Step 6: Test hostname resolution using getent
    getent hosts "$short_hostname"
	CHECK_RESULT $? 0 0 "mDNS resolution failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    hostnamectl set-hostname "$ORIG_HOSTNAME"
    mv /etc/nsswitch.conf.bak /etc/nsswitch.conf
    systemctl stop avahi-daemon.service avahi-daemon.socket
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"