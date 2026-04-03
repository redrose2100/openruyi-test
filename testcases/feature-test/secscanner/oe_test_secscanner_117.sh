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
# @Desc      :   set_umask test (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
UMASK_FILES=(
    "/etc/profile"
    "/etc/csh.login"
    "/etc/csh.cshrc"
    "/etc/bashrc"
    "/root/.bashrc"
    "/root/.cshrc"
)

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Backup each umask file if it exists
    for file in "${UMASK_FILES[@]}"; do
        if [[ -f "$file" && ! -f "${file}-bak" ]]; then
            \cp "$file" "${file}-bak"
        fi
    done
    # Comment out existing umask configuration if it exists
    for file in "${UMASK_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            sed -i 's/^umask.*/#umask/' "$file"
        fi
    done
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^set_umask.*/set_umask=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_umask=yes"
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if umask 027 is set in each file
    for file in "${UMASK_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            grep -E "umask 027" "$file"
            CHECK_RESULT $? 0 0 "umask 027 not set in $file"
        fi
    done
    # Run check again
    secscanner check level3 > tmp && \mv tmp check
    # Check OK message
    grep -i "umask" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "OK message not found"
    # Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    for file in "${UMASK_FILES[@]}"; do
        if [[ -f "${file}-bak" ]]; then
            \cp "${file}-bak" "$file"
        fi
    done
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Restore each umask file if backup exists
    for file in "${UMASK_FILES[@]}"; do
        if [[ -f "${file}-bak" ]]; then
            \cp "${file}-bak" "$file"
            rm -f "${file}-bak"
        fi
    done
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
