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
# @Author    :   kangjiangbo
# @Contact   :   kangjiangbo_yewu@cmss.chinamobile.com
# @Date      :   2026-4-2
# @License   :   Mulan PSL v2
# @Desc      :   enable_ssh test (set to yes, service running)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Start sshd service if it's not running
    systemctl start sshd
    sleep 2
    systemctl status sshd | grep -i "active (running)"
    CHECK_RESULT $? 0 0 "sshd service should be running"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Set enable_ssh=yes in secscanner.cfg
    sed -i 's/^enable_ssh.*/enable_ssh=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set enable_ssh=yes"
    secscanner check level3 > tmp && \mv tmp check
    # Execute secscanner fix level3 when service is running
    secscanner fix level3 > tmp && \mv tmp fix
    # Stop sshd service
    systemctl stop sshd
    sleep 2
    systemctl status sshd | grep -i "inactive (dead)"
    CHECK_RESULT $? 0 0 "sshd service should be stopped"
    # Execute secscanner fix level3 when service is stopped
    secscanner fix level3 > tmp && \mv tmp fix
    # Check output when service is stopped
    grep -i "SSH service successfully started" fix | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 3: Service start message not found"
    # Check if service is running
    systemctl status sshd | grep -i "active (running)"
    CHECK_RESULT $? 0 0 "sshd service should be running after fix"
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Ensure sshd service is running
    systemctl restart sshd
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

