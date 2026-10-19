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
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   set_nologin_list=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SYSTEM_AUTH_FILE="/etc/pam.d/system-auth"
PASSWORD_AUTH_FILE="/etc/pam.d/password-auth"
LOGIN_USER_DENY_FILE="/etc/login.user.deny"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SYSTEM_AUTH_FILE" && ! -f "${SYSTEM_AUTH_FILE}-bak" ]]; then
        \cp "$SYSTEM_AUTH_FILE" "${SYSTEM_AUTH_FILE}-bak"
        LOG_INFO "Backed up /etc/pam.d/system-auth"
    fi
    if [[ -f "$PASSWORD_AUTH_FILE" && ! -f "${PASSWORD_AUTH_FILE}-bak" ]]; then
        \cp "$PASSWORD_AUTH_FILE" "${PASSWORD_AUTH_FILE}-bak"
        LOG_INFO "Backed up /etc/pam.d/password-auth"
    fi
    if [[ -f "$LOGIN_USER_DENY_FILE" && ! -f "${LOGIN_USER_DENY_FILE}-bak" ]]; then
        \cp "$LOGIN_USER_DENY_FILE" "${LOGIN_USER_DENY_FILE}-bak"
        LOG_INFO "Backed up /etc/login.user.deny"
    fi
    sed -i '/pam_listfile.so.*login.user.deny/d' "$SYSTEM_AUTH_FILE"
    sed -i '/pam_listfile.so.*login.user.deny/d' "$PASSWORD_AUTH_FILE"
    rm -f "$LOGIN_USER_DENY_FILE"
    LOG_INFO "Removed existing nologin list configurations"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_nologin_list=no in secscanner.cfg
    sed -i 's/^set_nologin_list.*/set_nologin_list=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_nologin_list=no"
    # Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"
    # Execute secscanner fix basic and check configurations
    secscanner fix basic > tmp && \mv tmp fix
    # When set_nologin_list=no, pam_listfile should not be added
    grep -E "pam_listfile\.so.*login\.user\.deny" "$SYSTEM_AUTH_FILE"
    CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to system-auth"
    grep -E "pam_listfile\.so.*login\.user\.deny" "$PASSWORD_AUTH_FILE"
    CHECK_RESULT $? 1 0 "Step 3: pam_listfile should not be added to password-auth"
    # When set_nologin_list=no, login.user.deny should not be created
    test -f "$LOGIN_USER_DENY_FILE"
    CHECK_RESULT $? 1 0 "Step 3: /etc/login.user.deny should not be created"
    # Debug: Show current configurations
    LOG_INFO "Current system-auth configuration:"
    grep -i "pam_listfile" "$SYSTEM_AUTH_FILE"
    LOG_INFO "Current password-auth configuration:"
    grep -i "pam_listfile" "$PASSWORD_AUTH_FILE"
    # Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "list of users prohibited from login" check
    CHECK_RESULT $? 0 0 "Step 4: list of users prohibited from login check not found"
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
    if [[ -f "${SYSTEM_AUTH_FILE}-bak" ]]; then
        \cp "${SYSTEM_AUTH_FILE}-bak" "$SYSTEM_AUTH_FILE"
    fi
    if [[ -f "${PASSWORD_AUTH_FILE}-bak" ]]; then
        \cp "${PASSWORD_AUTH_FILE}-bak" "$PASSWORD_AUTH_FILE"
    fi
    if [[ -f "${LOGIN_USER_DENY_FILE}-bak" ]]; then
        \cp "${LOGIN_USER_DENY_FILE}-bak" "$LOGIN_USER_DENY_FILE"
    else
        rm -f "$LOGIN_USER_DENY_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

