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
# @Desc      :   expired_account test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SHADOW_FILE="/etc/shadow"
LOGIN_DEFS="/etc/login.defs"

# Test user
TEST_USER="testuser"
TEST_PASSWORD="Test@123"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SHADOW_FILE" && ! -f "${SHADOW_FILE}-bak" ]]; then
        \cp "$SHADOW_FILE" "${SHADOW_FILE}-bak"
    fi
    if [[ -f "$LOGIN_DEFS" && ! -f "${LOGIN_DEFS}-bak" ]]; then
        \cp "$LOGIN_DEFS" "${LOGIN_DEFS}-bak"
    fi
    # Set password policy: first remove existing PASS lines, then add new ones
    sed -i '/^PASS_MAX_DAYS/d' "$LOGIN_DEFS"
    sed -i '/^PASS_MIN_DAYS/d' "$LOGIN_DEFS"
    sed -i '/^PASS_MIN_LEN/d' "$LOGIN_DEFS"
    sed -i '/^PASS_WARN_AGE/d' "$LOGIN_DEFS"
    echo "PASS_MAX_DAYS  90" >> "$LOGIN_DEFS"
    echo "PASS_MIN_DAYS   6" >> "$LOGIN_DEFS"
    echo "PASS_MIN_LEN    5" >> "$LOGIN_DEFS"
    echo "PASS_WARN_AGE   30" >> "$LOGIN_DEFS"
    # Create test user
    useradd "$TEST_USER"
    echo "$TEST_PASSWORD" | passwd --stdin "$TEST_USER"
    # Modify account expiration date to yesterday
    yesterday=$(date -d "-1 day" +"%Y-%m-%d")
    chage -E "$yesterday" "$TEST_USER"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^expired_account.*/expired_account=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set expired_account=yes"
    # Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if test user exists in shadow file
    if grep -w "^$TEST_USER:" "$SHADOW_FILE"; then
        LOG_WARN "Test user $TEST_USER still exists in shadow file"
    else
        LOG_INFO "Test user $TEST_USER has been removed from shadow file"
    fi
    # Execute secscanner check level3 again
    secscanner check level3 > tmp && \mv tmp check
    # Check OK message
    grep -i "expired account" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "OK message not found"
    # Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if [[ -f "${SHADOW_FILE}-bak" ]]; then
        \cp "${SHADOW_FILE}-bak" "$SHADOW_FILE"
    fi
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${SHADOW_FILE}-bak" ]]; then
        \cp "${SHADOW_FILE}-bak" "$SHADOW_FILE"
        rm -f "${SHADOW_FILE}-bak"
    fi
    if [[ -f "${LOGIN_DEFS}-bak" ]]; then
        \cp "${LOGIN_DEFS}-bak" "$LOGIN_DEFS"
        rm -f "${LOGIN_DEFS}-bak"
    fi
    # Remove test user if exists
    userdel -r "$TEST_USER" >/dev/null 2>&1 || true
    groupdel "$TEST_USER" >/dev/null 2>&1 || true
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"