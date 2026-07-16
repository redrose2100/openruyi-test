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
# @Desc      :   nss-mdns configuration test (nsswitch.conf)
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    # Step 1: Prepare test environment, install nss-mdns package
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nss-mdns"
    
    # Step 2: Backup original nsswitch.conf
    cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 3: Check if mdns is already configured in nsswitch.conf
    if ! grep -E '^hosts:' /etc/nsswitch.conf | grep -q mdns; then
        # Step 4: Add mdns4_minimal to nsswitch.conf hosts line
        sed -i 's/^hosts: \(.*\)/hosts: mdns4_minimal \[NOTFOUND=return\] \1/' /etc/nsswitch.conf
        CHECK_RESULT $? 0 0 "Failed to configure nsswitch.conf"
    fi
    
    # Step 4: Verify mdns configuration in nsswitch.conf
    grep -E '^hosts:' /etc/nsswitch.conf | grep -q mdns
    CHECK_RESULT $? 0 0 "mdns not configured in nsswitch.conf"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    mv /etc/nsswitch.conf.bak /etc/nsswitch.conf
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"