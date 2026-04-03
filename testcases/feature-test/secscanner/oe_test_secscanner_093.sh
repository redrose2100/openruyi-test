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
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   password policy test (set_*=no)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LOGIN_DEFS_FILE="/etc/login.defs"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$LOGIN_DEFS_FILE" && ! -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "$LOGIN_DEFS_FILE" "${LOGIN_DEFS_FILE}-bak"
        LOG_INFO "Backed up /etc/login.defs"
    fi
    sed -i '/^PASS_MAX_DAYS/d' "$LOGIN_DEFS_FILE"
    sed -i '/^PASS_MIN_DAYS/d' "$LOGIN_DEFS_FILE"
    sed -i '/^PASS_MIN_LEN/d' "$LOGIN_DEFS_FILE"
    sed -i '/^PASS_WARN_AGE/d' "$LOGIN_DEFS_FILE"
    LOG_INFO "Removed existing password policy configurations"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set password policy configurations to no in secscanner.cfg
    sed -i 's/^set_pass_max_days.*/set_pass_max_days=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_len.*/set_pass_min_len=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_min_days.*/set_pass_min_days=no/' "$CONFIG_FILE"
    sed -i 's/^set_pass_warn_age.*/set_pass_warn_age=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set password policy configurations to no"
    # Execute secscanner check level3 before fix
    secscanner check level3 > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"
    # Execute secscanner fix level3 and check login.defs content
    secscanner fix level3 > tmp && \mv tmp fix
    # When set_*=no, password policy configurations should not be added
    grep -E "^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE)" "$LOGIN_DEFS_FILE"
    CHECK_RESULT $? 1 0 "Step 3: Password policy configurations should not be added"
    # Debug: Show current password policy configurations
    LOG_INFO "Current password policy configurations:"
    grep -E "^(PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_MIN_LEN|PASS_WARN_AGE)" "$LOGIN_DEFS_FILE"
    # Execute secscanner check level3 and check output
    secscanner check level3 > tmp && \mv tmp check
    grep -i "password lifetime" check
    CHECK_RESULT $? 0 0 "Step 4: password lifetime check not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "Step 5: Executed secscanner restore all"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${LOGIN_DEFS_FILE}-bak" ]]; then
        \cp "${LOGIN_DEFS_FILE}-bak" "$LOGIN_DEFS_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

