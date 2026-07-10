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
# @Date      :   2026-3-26
# @License   :   Mulan PSL v2
# @Desc      :   set_tmout test - when set to no (should not modify TMOUT)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PROFILE_FILE="/etc/profile"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup profile file if it exists
    if [[ -f "$PROFILE_FILE" && ! -f "${PROFILE_FILE}-bak" ]]; then
        \cp "$PROFILE_FILE" "${PROFILE_FILE}-bak"
    fi
    
    # Always modify configuration regardless of backup status
    if [[ -f "$PROFILE_FILE" ]]; then
        # Remove any existing TMOUT configuration
        sed -i '/^[[:space:]]*TMOUT=/d' "$PROFILE_FILE" 2>/dev/null
        sed -i '/^[[:space:]]*export TMOUT/d' "$PROFILE_FILE" 2>/dev/null
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_tmout=no in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_tmout.*/set_tmout=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_tmout=no"

    # Step 2: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix

    # Step 3: Verify TMOUT configuration is NOT added
    grep "TMOUT=180" "$PROFILE_FILE"
    CHECK_RESULT $? 1 0 "Profile file should not contain 'TMOUT=180' when set_tmout=no"
    grep "export TMOUT" "$PROFILE_FILE"
    CHECK_RESULT $? 1 0 "Profile file should not contain 'export TMOUT' when set_tmout=no"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original profile file from backup
    if [[ -f "${PROFILE_FILE}-bak" ]]; then
        \cp "${PROFILE_FILE}-bak" "$PROFILE_FILE"
    fi

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    DNF_REMOVE

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
