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
# @Desc      :   groupx_property test (set to no, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
GROUPX_FILE="/etc/group-"

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
    # Backup group- file
    if [[ -f "$GROUPX_FILE" && ! -f "${GROUPX_FILE}-bak" ]]; then
        \cp "$GROUPX_FILE" "${GROUPX_FILE}-bak"
    fi
    # Record original permission
    original_perm=$(stat -c "%A" "$GROUPX_FILE")
    LOG_INFO "Original /etc/group- permission: $original_perm"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set groupx_property=no in secscanner.cfg
    sed -i 's/^groupx_property.*/groupx_property=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set groupx_property=no"
    # Step 2: Change file permission to 444
    chmod 444 "$GROUPX_FILE"
    CHECK_RESULT $? 0 0 "Failed to change /etc/group- permission to 444"
    current_perm=$(stat -c "%a" "$GROUPX_FILE")
    LOG_INFO "Current /etc/group- permission: $current_perm"
    # Step 3: Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 4: Check if permission remains unchanged
    current_perm=$(stat -c "%a" "$GROUPX_FILE")
    if test "$current_perm" = "444"; then
        LOG_INFO "/etc/group- permission remains 444 (as expected)"
    else
        LOG_WARN "/etc/group- permission was changed to $current_perm (unexpected)"
    fi
    # Step 5: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if test -f "${GROUPX_FILE}-bak"; then
        \cp "${GROUPX_FILE}-bak" "$GROUPX_FILE"
    fi
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if test -f "${CONFIG_FILE}-bak"; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if test -f "${GROUPX_FILE}-bak"; then
        \cp "${GROUPX_FILE}-bak" "$GROUPX_FILE"
        rm -f "${GROUPX_FILE}-bak"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
