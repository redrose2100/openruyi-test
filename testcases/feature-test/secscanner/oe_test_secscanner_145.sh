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
# @Date      :   2026-4-3
# @License   :   Mulan PSL v2
# @Desc      :   set_selinux test (set to no, level3)
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
    # Step 1: Set set_selinux=no in secscanner.cfg
    sed -i 's/^set_selinux=.*/set_selinux=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_selinux=no"
    # Step 2: Set SELINUX to disabled
    sed -i 's/^SELINUX=.*/SELINUX=disabled/' "$SELINUX_CONFIG"
    CHECK_RESULT $? 0 0 "Failed to set SELINUX=disabled"
    # Step 3: Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 4: Check if SELINUX remains disabled
    current_selinux=$(grep "^SELINUX=" "$SELINUX_CONFIG" | cut -d= -f2)
    if [[ "$current_selinux" == "disabled" ]]; then
        LOG_INFO "SELINUX remains disabled (as expected)"
    else
        LOG_WARN "SELINUX was changed to $current_selinux (unexpected)"
        CHECK_RESULT 1 0 0 "SELINUX is not set to disabled, current value: $current_selinux"
    fi
    # Step 5: Check restore
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
