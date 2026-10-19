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
# @Date      :   2026-3-26
# @License   :   Mulan PSL v2
# @Desc      :   Password policy test - when values already exist in login.defs
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LOGIN_DEFS_FILE="/etc/login.defs"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup login.defs file if it exists
    if [[ -f "$LOGIN_DEFS_FILE" && ! -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "$LOGIN_DEFS_FILE" "${LOGIN_DEFS_FILE}-bak"
    fi
    
    # Always modify configuration regardless of backup status
    if [[ -f "$LOGIN_DEFS_FILE" ]]; then
        # Remove any existing password policy configuration
        sed -i '/^PASS_MAX_DAYS/d' "$LOGIN_DEFS_FILE" 
        sed -i '/^PASS_MIN_DAYS/d' "$LOGIN_DEFS_FILE" 
        sed -i '/^PASS_MIN_LEN/d' "$LOGIN_DEFS_FILE" 
        sed -i '/^PASS_WARN_AGE/d' "$LOGIN_DEFS_FILE" 
        # Add different values
        {
            echo "PASS_MAX_DAYS 180"
            echo "PASS_MIN_DAYS 3"
            echo "PASS_MIN_LEN 8"
            echo "PASS_WARN_AGE 14"
        } >> "$LOGIN_DEFS_FILE"      
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set password policy configuration in secscanner.cfg
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_pass_max_days.*/set_pass_max_days=yes/' "$CONFIG_FILE"
    sed -i 's/^pass_max_days_value.*/pass_max_days_value=90/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_len.*/set_pass_min_len=yes/' "$CONFIG_FILE"
    sed -i 's/^pass_min_len_value.*/pass_min_len_value=10/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_days.*/set_pass_min_days=yes/' "$CONFIG_FILE"
    sed -i 's/^pass_min_days_value.*/pass_min_days_value=6/' "$CONFIG_FILE"
    sed -i 's/^set_pass_warn_age.*/set_pass_warn_age=yes/' "$CONFIG_FILE"
    sed -i 's/^pass_warn_age_value.*/pass_warn_age_value=30/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set password policy configuration"

    # Step 2: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix

    # Step 3: Verify login.defs contains correct configuration
    grep "PASS_MAX_DAYS" "$LOGIN_DEFS_FILE" | grep 90
    CHECK_RESULT $? 0 0 "login.defs missing PASS_MAX_DAYS 90"
    grep "PASS_MIN_DAYS" "$LOGIN_DEFS_FILE" | grep 6
    CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_DAYS 6"
    grep "PASS_MIN_LEN" "$LOGIN_DEFS_FILE" | grep 10
    CHECK_RESULT $? 0 0 "login.defs missing PASS_MIN_LEN 10"
    grep "PASS_WARN_AGE" "$LOGIN_DEFS_FILE" | grep 30
    CHECK_RESULT $? 0 0 "login.defs missing PASS_WARN_AGE 30"
    # Verify old values are not present
    grep "PASS_MAX_DAYS" "$LOGIN_DEFS_FILE" | grep 180
    CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MAX_DAYS 180"
    grep "PASS_MIN_DAYS" "$LOGIN_DEFS_FILE" | grep 3
    CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MIN_DAYS 3"
    grep "PASS_MIN_LEN" "$LOGIN_DEFS_FILE" | grep 8
    CHECK_RESULT $? 1 0 "login.defs should not contain PASS_MIN_LEN 8"
    grep "PASS_WARN_AGE" "$LOGIN_DEFS_FILE" | grep 14
    CHECK_RESULT $? 1 0 "login.defs should not contain PASS_WARN_AGE 14"

    # Step 4: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep "$LOGIN_DEFS_FILE" restore | grep FINISHED
    CHECK_RESULT $? 0 0 "Restore output missing for $LOGIN_DEFS_FILE"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original login.defs file from backup
    if [[ -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "${LOGIN_DEFS_FILE}-bak" "${LOGIN_DEFS_FILE}"
    fi

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
