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
# @Desc      :   group_property test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
GROUP_FILE="/etc/group"

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
    # Backup group file
    if [[ -f "$GROUP_FILE" && ! -f "${GROUP_FILE}-bak" ]]; then
        \cp "$GROUP_FILE" "${GROUP_FILE}-bak"
    fi
    # Record original permission
    original_perm=$(stat -c "%A" "$GROUP_FILE")
    LOG_INFO "Original /etc/group permission: $original_perm"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set group_property=yes in secscanner.cfg
    sed -i 's/^group_property.*/group_property=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set group_property=yes"
    # Step 2: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 3: Change file permission to 444
    chmod 444 "$GROUP_FILE"
    CHECK_RESULT $? 0 0 "Failed to change /etc/group permission to 444"
    current_perm=$(stat -c "%a" "$GROUP_FILE")
    LOG_INFO "Current /etc/group permission: $current_perm"
    # Step 4: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Check WARNING message
    grep -i "group.*property" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "WARNING message not found"
    # Step 5: Execute secscanner fix level3 again
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if permission is fixed
    current_perm=$(stat -c "%a" "$GROUP_FILE")
    LOG_INFO "Fixed /etc/group permission: $current_perm"
    # Step 6: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if test -f "${GROUP_FILE}-bak"; then
        \cp "${GROUP_FILE}-bak" "$GROUP_FILE"
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
    if test -f "${GROUP_FILE}-bak"; then
        \cp "${GROUP_FILE}-bak" "$GROUP_FILE"
        rm -f "${GROUP_FILE}-bak"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
