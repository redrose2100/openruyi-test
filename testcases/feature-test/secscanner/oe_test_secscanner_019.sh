#!/usr/bin/env bash

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
# @Desc      :   set_file_property test (file and directory permissions)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

# Define files and their expected permissions
declare -A FILE_PERMISSIONS
FILE_PERMISSIONS[/etc/passwd]=644
FILE_PERMISSIONS[/etc/group]=644
FILE_PERMISSIONS[/etc/shadow]=400
FILE_PERMISSIONS[/etc/lilo.conf]=600

# Store original permissions
declare -A ORIGINAL_PERMISSIONS

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup original permissions
    for file in "${!FILE_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            ORIGINAL_PERMISSIONS[$file]=$(stat -c %a "$file")
            LOG_INFO "Original permission for $file: ${ORIGINAL_PERMISSIONS[$file]}"
        fi
    done

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_file_property=yes in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_file_property.*/set_file_property=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_file_property=yes"

    # Step 2: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix

    # Step 3: Verify permissions are set correctly
    for file in "${!FILE_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            current_perm=$(stat -c %a "$file")
            expected_perm=${FILE_PERMISSIONS[$file]}
            CHECK_RESULT "$current_perm" "$expected_perm" 0 "Permission for $file is $current_perm, expected $expected_perm"
        else
            LOG_INFO "File $file does not exist, skipping permission check"
        fi
    done

    # Step 4: Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    for file in "${!FILE_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            if [[ -d "$file" ]]; then
                grep -i "dir $file" check | grep -i "ok"
            else
                grep -i "$file" check | grep -i "ok"
            fi
            CHECK_RESULT $? 0 0 "Check output missing for $file"
        fi
    done

    # Step 5: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    for file in "${!FILE_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            grep "$file" restore | grep FINISHED
            CHECK_RESULT $? 0 0 "Restore output missing for $file"
        fi
    done

    # Step 6: Verify permissions are restored
    for file in "${!ORIGINAL_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            current_perm=$(stat -c %a "$file")
            original_perm=${ORIGINAL_PERMISSIONS[$file]}
            CHECK_RESULT "$current_perm" "$original_perm" 0 "Permission for $file is $current_perm, expected original $original_perm"
        fi
    done

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original permissions if restore failed
    for file in "${!ORIGINAL_PERMISSIONS[@]}"; do
        if [[ -e "$file" ]]; then
            chmod "${ORIGINAL_PERMISSIONS[$file]}" "$file" 2>/dev/null
        fi
    done

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
