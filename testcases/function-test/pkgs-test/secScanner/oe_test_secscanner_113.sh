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
# @Desc      :   rootUID_unique test (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
PASSWD_FILE="/etc/passwd"
TEST_USER="test_uid0"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$PASSWD_FILE" && ! -f "${PASSWD_FILE}-bak" ]]; then
        \cp "$PASSWD_FILE" "${PASSWD_FILE}-bak"
    fi
    # Remove test user if exists
    userdel -r "$TEST_USER" 2>/dev/null || true
    # Check if only root has UID 0
    awk -F: '($3 == 0) { print $1 }' "$PASSWD_FILE"
    CHECK_RESULT $? 0 0 "Failed to check UID 0 users"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^rootUID_unique.*/rootUID_unique=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set rootUID_unique=yes"
    # Add a test user with UID 0
    echo "$TEST_USER:x:0:0:root:/root:/bin/bash" >> "$PASSWD_FILE"
    CHECK_RESULT $? 0 0 "Failed to add test user"
    # Check if test user exists
    grep "$TEST_USER" "$PASSWD_FILE"
    CHECK_RESULT $? 0 0 "Test user not found"
    # Run check again
    secscanner check level3 > tmp && \mv tmp check
    # Run fix again
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if test user is removed
    grep "$TEST_USER" "$PASSWD_FILE"
    CHECK_RESULT $? 1 0 "Test user should be removed"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${PASSWD_FILE}-bak" ]]; then
        \cp "${PASSWD_FILE}-bak" "$PASSWD_FILE"
    fi
    # Remove test user if exists
    userdel -rf "$TEST_USER" 2>/dev/null || true
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
