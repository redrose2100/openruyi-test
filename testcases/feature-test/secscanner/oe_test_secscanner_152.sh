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
# @Desc      :   set_tmout test with no existing TMOUT configuration (set to yes)
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
    LOG_INFO "Removed existing TMOUT configuration"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_tmout=yes in secscanner.cfg
    sed -i 's/^set_tmout.*/set_tmout=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_tmout=yes"
    # Step 2: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Check WARNING message
    grep -i "tmout" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "WARNING message not found"
    # Step 3: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if TMOUT is added with value 180
    grep -E "^TMOUT=180" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 3: TMOUT not set to 180"
    grep -E "^export TMOUT" "$PROFILE_FILE"
    CHECK_RESULT $? 0 0 "Step 3: export TMOUT not found"
    # Step 4: Execute secscanner check level3 again
    secscanner check level3 > tmp && \mv tmp check
    # Check OK message
    grep -i "Has right TMOUT set" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 4: OK message not found"
    # Step 5: Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Check restore message
    grep -i "/etc/profile" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
    # Check if TMOUT configuration is removed
    grep -E "^TMOUT=" "$PROFILE_FILE"
    CHECK_RESULT $? 1 0 "Step 6: TMOUT configuration not removed"
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