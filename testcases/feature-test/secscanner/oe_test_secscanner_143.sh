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
# @Desc      :   gshadowx_property test (set to no, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
GSHADOWX_FILE="/etc/gshadow-"

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
    # Backup gshadow- file
    if [[ -f "$GSHADOWX_FILE" && ! -f "${GSHADOWX_FILE}-bak" ]]; then
        \cp "$GSHADOWX_FILE" "${GSHADOWX_FILE}-bak"
    fi
    # Record original permission
    original_perm=$(ls -l "$GSHADOWX_FILE" | awk '{print $1}')
    LOG_INFO "Original /etc/gshadow- permission: $original_perm"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set gshadowx_property=no in secscanner.cfg
    sed -i 's/^gshadowx_property.*/gshadowx_property=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set gshadowx_property=no"
    # Step 2: Change file permission to 444
    chmod 444 "$GSHADOWX_FILE"
    CHECK_RESULT $? 0 0 "Failed to change /etc/gshadow- permission to 444"
    current_perm=$(ls -l "$GSHADOWX_FILE" | awk '{print $1}')
    LOG_INFO "Current /etc/gshadow- permission: $current_perm"
    # Step 3: Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Step 4: Check if permission remains unchanged
    current_perm=$(ls -l "$GSHADOWX_FILE" | awk '{print $1}')
    if [[ "$current_perm" == "-r--r--r--" ]]; then
        LOG_INFO "/etc/gshadow- permission remains 444 (as expected)"
    else
        LOG_WARN "/etc/gshadow- permission was changed to $current_perm (unexpected)"
    fi
    # Step 5: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if [[ -f "${GSHADOWX_FILE}-bak" ]]; then
        \cp "${GSHADOWX_FILE}-bak" "$GSHADOWX_FILE"
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
    if [[ -f "${GSHADOWX_FILE}-bak" ]]; then
        \cp "${GSHADOWX_FILE}-bak" "$GSHADOWX_FILE"
        rm -f "${GSHADOWX_FILE}-bak"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
