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
# @Date      :   2026-3-31
# @License   :   Mulan PSL v2
# @Desc      :   set_always_set_path=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LOGIN_DEFS_FILE="/etc/login.defs"

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

    # Backup login.defs file
    if [[ -f "$LOGIN_DEFS_FILE" && ! -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "$LOGIN_DEFS_FILE" "${LOGIN_DEFS_FILE}-bak"
        LOG_INFO "Backed up /etc/login.defs"
    fi

    # Remove existing ALWAYS_SET_PATH configuration for testing
    sed -i '/^ALWAYS_SET_PATH/d' "$LOGIN_DEFS_FILE"
    LOG_INFO "Removed existing ALWAYS_SET_PATH configuration"

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_always_set_path=no in secscanner.cfg
    sed -i 's/^set_always_set_path.*/set_always_set_path=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_always_set_path=no"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check

    # Step 3: Execute secscanner fix basic and check login.defs content
    secscanner fix basic > tmp && \mv tmp fix
    # When set_always_set_path=no, ALWAYS_SET_PATH should not be added
    grep -E "^ALWAYS_SET_PATH" "$LOGIN_DEFS_FILE"
    CHECK_RESULT $? 1 0 "Step 3: ALWAYS_SET_PATH should not be added"

    # Step 4: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/login.defs" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "${LOGIN_DEFS_FILE}-bak" "$LOGIN_DEFS_FILE"
    fi

    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f fix check restore tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"

