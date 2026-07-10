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
# @Desc      :   Password policy test - when set to no (should not modify login.defs)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LOGIN_DEFS_FILE="/etc/login.defs"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup login.defs file if it exists
    if [[ -f "$LOGIN_DEFS_FILE" && ! -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "$LOGIN_DEFS_FILE" "${LOGIN_DEFS_FILE}-bak"
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set password policy configuration to no in secscanner.cfg
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_pass_max_days.*/set_pass_max_days=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_len.*/set_pass_min_len=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_days.*/set_pass_min_days=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_warn_age.*/set_pass_warn_age=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set password policy configuration to no"

    # Step 2: Record original configuration before fix
    declare -A original_config
    if [[ -f "$LOGIN_DEFS_FILE" ]]; then
        # Record existing password policy configurations
        original_config[PASS_MAX_DAYS]=$(grep "^PASS_MAX_DAYS" "$LOGIN_DEFS_FILE" || echo "")
        original_config[PASS_MIN_DAYS]=$(grep "^PASS_MIN_DAYS" "$LOGIN_DEFS_FILE" || echo "")
        original_config[PASS_MIN_LEN]=$(grep "^PASS_MIN_LEN" "$LOGIN_DEFS_FILE" || echo "")
        original_config[PASS_WARN_AGE]=$(grep "^PASS_WARN_AGE" "$LOGIN_DEFS_FILE" || echo "")
        LOG_INFO "Original PASS_MAX_DAYS: ${original_config[PASS_MAX_DAYS]}"
        LOG_INFO "Original PASS_MIN_DAYS: ${original_config[PASS_MIN_DAYS]}"
        LOG_INFO "Original PASS_MIN_LEN: ${original_config[PASS_MIN_LEN]}"
        LOG_INFO "Original PASS_WARN_AGE: ${original_config[PASS_WARN_AGE]}"
    fi

    # Step 3: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix

    # Step 4: Verify login.defs is NOT modified
    if [[ -f "$LOGIN_DEFS_FILE" ]]; then
        # Check that existing configurations are unchanged
        current_config[PASS_MAX_DAYS]=$(grep "^PASS_MAX_DAYS" "$LOGIN_DEFS_FILE" || echo "")
        current_config[PASS_MIN_DAYS]=$(grep "^PASS_MIN_DAYS" "$LOGIN_DEFS_FILE" || echo "")
        current_config[PASS_MIN_LEN]=$(grep "^PASS_MIN_LEN" "$LOGIN_DEFS_FILE" || echo "")
        current_config[PASS_WARN_AGE]=$(grep "^PASS_WARN_AGE" "$LOGIN_DEFS_FILE" || echo "")
        
        LOG_INFO "Current PASS_MAX_DAYS: ${current_config[PASS_MAX_DAYS]}"
        LOG_INFO "Current PASS_MIN_DAYS: ${current_config[PASS_MIN_DAYS]}"
        LOG_INFO "Current PASS_MIN_LEN: ${current_config[PASS_MIN_LEN]}"
        LOG_INFO "Current PASS_WARN_AGE: ${current_config[PASS_WARN_AGE]}"
        
        # Verify configurations are unchanged
        [[ "${current_config[PASS_MAX_DAYS]}" == "${original_config[PASS_MAX_DAYS]}" ]] && LOG_INFO "PASS_MAX_DAYS is unchanged"
        [[ "${current_config[PASS_MIN_DAYS]}" == "${original_config[PASS_MIN_DAYS]}" ]] && LOG_INFO "PASS_MIN_DAYS is unchanged"
        [[ "${current_config[PASS_MIN_LEN]}" == "${original_config[PASS_MIN_LEN]}" ]] && LOG_INFO "PASS_MIN_LEN is unchanged"
        [[ "${current_config[PASS_WARN_AGE]}" == "${original_config[PASS_WARN_AGE]}" ]] && LOG_INFO "PASS_WARN_AGE is unchanged"
    fi

    # Step 5: Execute secscanner restore all and check output
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
