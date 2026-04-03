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
# @Desc      :   expired_account test (set to no, level3)
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
    sed -i 's/^expired_account.*/expired_account=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set expired_account=no"
    # Execute secscanner fix level3
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if test user still exists in shadow file
    grep -w "^$TEST_USER:" "$SHADOW_FILE"
    if [[ $? -eq 0 ]]; then
        LOG_INFO "Test user $TEST_USER still exists in shadow file (as expected)"
    else
        LOG_WARN "Test user $TEST_USER has been removed from shadow file (unexpected)"
    fi
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

    # Remove test user if exists
    userdel -r "$TEST_USER" >/dev/null 2>&1 || true
    groupdel "$TEST_USER" >/dev/null 2>&1 || true
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
