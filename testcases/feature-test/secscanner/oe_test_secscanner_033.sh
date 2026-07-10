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
# @Date      :   2026-3-27
# @License   :   Mulan PSL v2
# @Desc      :   disable_unused_software test - when set to no (should not stop services)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SERVICE_NAME="telnet.socket"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup secscanner configuration file
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    
    # Install telnet-server if not installed
    if ! rpm -q telnet-server >/dev/null 2>&1; then
        DNF_INSTALL "telnet-server"
    fi
    
    # Start telnet.socket service for testing
    systemctl start "$SERVICE_NAME" 2>/dev/null
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set disable_unused_software=no in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^disable_unused_software.*/disable_unused_software=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set disable_unused_software=no"
    
    secscanner check basic > tmp && \mv tmp check
    # Step 2: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    
    # Step 3: Check if telnet.socket service is still running
    systemctl status "$SERVICE_NAME" |grep -q "active"
    CHECK_RESULT $? 0 0 "$SERVICE_NAME should still be running when disable_unused_software=no"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore secScanner configuration
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    
    # Restore telnet.socket service status
    systemctl stop "$SERVICE_NAME" 2>/dev/null

    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp service_status_before.txt service_status_after.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
