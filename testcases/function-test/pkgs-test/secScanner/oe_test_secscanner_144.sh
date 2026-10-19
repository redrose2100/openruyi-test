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
# @Desc      :   set_selinux test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SELINUX_CONFIG="/etc/selinux/config"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Backup selinux config file
    if [[ -f "$SELINUX_CONFIG" && ! -f "${SELINUX_CONFIG}-bak" ]]; then
        \cp "$SELINUX_CONFIG" "${SELINUX_CONFIG}-bak"
    fi
    # Record original SELINUX value
    original_selinux=$(grep "^SELINUX=" "$SELINUX_CONFIG" | cut -d= -f2)
    LOG_INFO "Original SELINUX value: $original_selinux"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_selinux=yes in secscanner.cfg
    sed -i 's/^set_selinux=.*/set_selinux=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_selinux=yes"
    # Step 2: Set SELINUX to disabled first
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' "$SELINUX_CONFIG"
    CHECK_RESULT $? 0 0 "Failed to set SELINUX=disabled"
    # Step 3: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Check WARNING message
    grep -i "selinux.*set" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "WARNING message not found"
    # Step 4: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if SELINUX is set to enforcing or permissive
    current_selinux=$(grep "^SELINUX=" "$SELINUX_CONFIG" | cut -d= -f2)
    if [[ "$current_selinux" == "enforcing" || "$current_selinux" == "permissive" ]]; then
        LOG_INFO "SELINUX is set to $current_selinux (as expected)"
        CHECK_RESULT 0 0 0 "SELINUX is set to $current_selinux"
    else
        LOG_ERROR "SELINUX is not set to enforcing or permissive, current value: $current_selinux"
        CHECK_RESULT 1 0 0 "SELINUX is not set to enforcing or permissive, current value: $current_selinux"
    fi
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
    if [[ -f "${SELINUX_CONFIG}-bak" ]]; then
        \cp "${SELINUX_CONFIG}-bak" "$SELINUX_CONFIG"
        rm -f "${SELINUX_CONFIG}-bak"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
