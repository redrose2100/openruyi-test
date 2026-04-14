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
# @Author    :   liyongqiang
# @Contact   :   liyongqiang_yewu@cmss.chinamobile.com
# @Date      :   2026-4-13
# @License   :   Mulan PSL v2
# @Desc      :   set_audit test (auditd not installed, set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

# Global variables
auditd_installed=""

auditd_status=""

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Check if auditd is installed
    if rpm -q audit >/dev/null 2>&1; then
        auditd_installed="yes"
        # Check auditd status
        auditd_status=$(systemctl is-enabled auditd 2>/dev/null || echo "disabled")
        LOG_INFO "Original auditd status: $auditd_status (installed)"
    else
        auditd_installed="no"
        auditd_status="disabled"
        LOG_INFO "Original auditd status: not installed"
        # Install auditd
        DNF_INSTALL "audit"
    fi
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_audit=yes in secscanner.cfg
    sed -i 's/^set_audit=.*/set_audit=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_audit=yes"
    # Step 2: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Step 3: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if auditd is installed and enabled
    rpm -q audit
    CHECK_RESULT $? 0 0 "Step 3: auditd should be installed"
    auditd_status=$(systemctl is-enabled auditd 2>/dev/null || echo "disabled")
    if [[ "$auditd_status" == "enabled" ]]; then
        LOG_INFO "auditd is enabled (as expected)"
    else    
        LOG_WARN "auditd is not enabled, current status: $auditd_status"
        CHECK_RESULT 1 0 0 "auditd is not enabled, current status: $auditd_status"
    fi
    # Step 4: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Restore original auditd state
    if [[ "$auditd_installed" == "yes" ]]; then
        # Install auditd
        DNF_INSTALL "audit"
        # Restore auditd status
        if [[ "$auditd_status" == "enabled" ]]; then
            systemctl enable auditd
            LOG_INFO "Restored auditd to enabled status"
        else
            systemctl disable auditd
            LOG_INFO "Restored auditd to disabled status"
        fi
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"