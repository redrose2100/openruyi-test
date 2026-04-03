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
# @Desc      :   overdue_passwd test (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SHADOW_FILE="/etc/shadow"
TEST_USER="test_expired"
TEST_PASSWORD="Test@1234!"

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
    # Remove test user if exists
    groupdel "$TEST_USER" 2>/dev/null || true
    userdel -r "$TEST_USER" 2>/dev/null || true
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^overdue_passwd.*/overdue_passwd=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set overdue_passwd=yes"
    # Create test user and set password
    useradd "$TEST_USER"
    CHECK_RESULT $? 0 0 "Failed to create test user"
    echo "$TEST_PASSWORD" | passwd --stdin "$TEST_USER"
    CHECK_RESULT $? 0 0 "Failed to set password"
    # Record user info
    chage -l "$TEST_USER"
    # Modify password change date to yesterday
    yesterday=$(date -d "-1 day" +"%Y-%m-%d")
    chage -d "$yesterday" "$TEST_USER"
    CHECK_RESULT $? 0 0 "Failed to set password change date"
    # Set password to expire immediately
    chage -d 0 "$TEST_USER"
    CHECK_RESULT $? 0 0 "Failed to set password to expire"
    # Check user exists
    grep "$TEST_USER" "$SHADOW_FILE"
    CHECK_RESULT $? 0 0 "Test user not found in shadow"
    # Run check again
    secscanner check level3 > tmp && \mv tmp check
    # Run fix again
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if user is removed
    grep "$TEST_USER" "$SHADOW_FILE"
    CHECK_RESULT $? 1 0 "Test user should be removed"
    # Check restore
    secscanner restore all -y > tmp && \mv tmp restore
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
    fi
    # Remove test user if exists
    userdel -rf "$TEST_USER" 2>/dev/null || true
    groupdel "$TEST_USER" 2>/dev/null || true
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
