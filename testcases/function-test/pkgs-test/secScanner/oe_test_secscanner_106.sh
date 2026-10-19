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
# @Desc      :   disable_telnet test (set to no)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install telnet if not installed
    yum search telnet-server || exit 0
    DNF_INSTALL "telnet-server"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Start telnet.socket if it's not running
    systemctl start telnet.socket
    sleep 2
    systemctl status telnet.socket | grep -i "Active: active"
    CHECK_RESULT $? 0 0 "telnet.socket should be running"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Set disable_telnet=no in secscanner.cfg
    sed -i 's/^disable_telnet.*/disable_telnet=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set disable_telnet=no"
    secscanner check level3 > tmp && \mv tmp check
    # Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if telnet.socket is still running
    systemctl status telnet.socket | grep -i "Active: active"
    CHECK_RESULT $? 0 0 "Step 3: telnet.socket should remain running"
    # Execute secscanner check level3 and check output
    secscanner check level3 > tmp && \mv tmp check
    # Check if check output shows appropriate message
    grep -i "Telnet" check
    CHECK_RESULT $? 0 0 "Step 4: Telnet check message not found"
    LOG_INFO "All checks finished."
    secscanner restore all -y > tmp && \mv tmp restore
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Ensure telnet.socket is stopped
    systemctl stop telnet.socket
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

