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
# @Desc      :   set_tmout test (set to no, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PROFILE_FILE="/etc/profile"

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
    # Backup profile file
    if [[ -f "$PROFILE_FILE" && ! -f "${PROFILE_FILE}-bak" ]]; then
        \cp "$PROFILE_FILE" "${PROFILE_FILE}-bak"
        LOG_INFO "Backed up /etc/profile"
    fi
    # Remove existing TMOUT configuration
    sed -i '/^TMOUT/d' "$PROFILE_FILE"
    sed -i '/^export TMOUT/d' "$PROFILE_FILE"
    # Add TMOUT configuration
    echo "TMOUT=180" >> "$PROFILE_FILE"
    echo "export TMOUT" >> "$PROFILE_FILE"
    LOG_INFO "Added TMOUT=180 configuration"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_tmout=no in secscanner.cfg
    sed -i 's/^set_tmout.*/set_tmout=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_tmout=no"
    # Step 2: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Step 3: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if TMOUT configuration remains unchanged
    grep -E "^TMOUT=180" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 3: TMOUT configuration should remain unchanged when set_tmout=no"
    grep -E "^export TMOUT" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 3: export TMOUT should remain unchanged when set_tmout=no"
    # Step 4: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Check restore message
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${PROFILE_FILE}-bak" ]]; then
        \cp "${PROFILE_FILE}-bak" "$PROFILE_FILE"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"