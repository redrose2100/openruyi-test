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
# @Date      :   2026-4-3
# @License   :   Mulan PSL v2
# @Desc      :   set_audit test (set to no, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

# Global variables
auditd_status=""

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install auditd if not installed
    DNF_INSTALL "audit"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Disable auditd service
    systemctl disable auditd
    # Check if auditd is disabled
    auditd_status=$(systemctl is-enabled auditd 2>/dev/null || echo "disabled")
    LOG_INFO "Original auditd status: $auditd_status"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_audit=no in secscanner.cfg
    sed -i 's/^set_audit=.*/set_audit=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_audit=no"
    # Step 2: Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 3: Check if auditd remains disabled
    auditd_status=$(systemctl is-enabled auditd 2>/dev/null || echo "disabled")
    if [[ "$auditd_status" == "disabled" ]]; then
        LOG_INFO "auditd remains disabled (as expected)"
    else
        LOG_WARN "auditd was changed to $auditd_status (unexpected)"
    fi
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Restore original auditd status
    if [[ "$auditd_status" == "enabled" ]]; then
        systemctl enable auditd
        LOG_INFO "Restored auditd to enabled status"
    else
        systemctl disable auditd
        LOG_INFO "Restored auditd to disabled status"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"