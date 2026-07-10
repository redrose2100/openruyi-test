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
# @Date      :   2026-3-31
# @License   :   Mulan PSL v2
# @Desc      :   set_log_file_property test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LOG_FILES=("/var/log/messages" "/var/log/secure" "/var/log/cron" "/var/log/spooler" "/var/log/boot.log")

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi

    # Record original permissions
    for file in "${LOG_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            original_perm=$(stat -c %a "$file")
            echo "$file:$original_perm" >> log_perm_original.txt
            LOG_INFO "Original permission for $file: $original_perm"
        fi
    done

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_log_file_property=yes in secscanner.cfg
    sed -i 's/^set_log_file_property.*/set_log_file_property=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_log_file_property=yes"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"

    # Step 3: Execute secscanner fix basic and check log file permissions
    secscanner fix basic > tmp && \mv tmp fix
    for file in "${LOG_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            current_perm=$(stat -c %a "$file")
            if [[ "$current_perm" != "600" ]]; then
                CHECK_RESULT 1 0 "Step 2: $file permission is not 600, got $current_perm"
            else
                LOG_INFO "Step 2: $file permission is 600"
            fi
        else
            LOG_INFO "Step 2: $file does not exist, skipping test"
        fi
    done

    # Step 4: Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "check log file property" check
    CHECK_RESULT $? 0 0 "Step 4: log file property check not found"
    
    # Check each log file only if it exists
    for file in "${LOG_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            filename=$(basename "$file")
            grep -i "$filename" check | grep -i "ok"
            CHECK_RESULT $? 0 0 "Step 4: $filename check not found"
        else
            LOG_INFO "Step 4: $file does not exist, skipping check"
        fi
    done

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi

    # Restore original permissions
    if [[ -f "log_perm_original.txt" ]]; then
        while IFS=":" read -r file perm; do
            if [[ -f "$file" ]]; then
                chmod "$perm" "$file"
                LOG_INFO "Restored $file permission to $perm"
            fi
        done < log_perm_original.txt
    fi

    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f fix check tmp log_perm_original.txt

    LOG_INFO "End to restore the test environment."
}

main "$@"
