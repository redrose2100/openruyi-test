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
# @Desc      :   passwdx_property test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PASSWDX_FILE="/etc/passwd-"

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
    # Backup passwd- file
    if [[ -f "$PASSWDX_FILE" && ! -f "${PASSWDX_FILE}-bak" ]]; then
        \cp "$PASSWDX_FILE" "${PASSWDX_FILE}-bak"
    fi
    # Record original permission
    original_perm=$(stat -c "%A" "$PASSWDX_FILE")
    LOG_INFO "Original /etc/passwd- permission: $original_perm"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set passwdx_property=yes in secscanner.cfg
    sed -i 's/^passwdx_property.*/passwdx_property=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set passwdx_property=yes"
    # Step 2: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 3: Change file permission to 444
    chmod 444 "$PASSWDX_FILE"
    CHECK_RESULT $? 0 0 "Failed to change /etc/passwd- permission to 444"
    current_perm=$(stat -c "%a" "$PASSWDX_FILE")
    LOG_INFO "Current /etc/passwd- permission: $current_perm"
    # Step 4: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Check WARNING message
    grep -i "passwdx.*property" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "WARNING message not found"
    # Step 5: Execute secscanner fix level3 again
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if permission is fixed
    current_perm=$(stat -c "%a" "$PASSWDX_FILE")
    LOG_INFO "Fixed /etc/passwd- permission: $current_perm"
    # Step 6: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if test -f "${PASSWDX_FILE}-bak"; then
        \cp "${PASSWDX_FILE}-bak" "$PASSWDX_FILE"
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
    if test -f "${PASSWDX_FILE}-bak"; then
        \cp "${PASSWDX_FILE}-bak" "$PASSWDX_FILE"
        rm -f "${PASSWDX_FILE}-bak"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
