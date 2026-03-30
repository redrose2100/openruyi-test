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
# @Date      :   2026-3-27
# @License   :   Mulan PSL v2
# @Desc      :   Core dump setting test - when set to no
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration files
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
LIMITS_CONFIG_FILE="/etc/security/limits.conf"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi

    if [[ -f "$LIMITS_CONFIG_FILE" && ! -f "${LIMITS_CONFIG_FILE}-bak" ]]; then
        \cp "$LIMITS_CONFIG_FILE" "${LIMITS_CONFIG_FILE}-bak"
    fi

    # Remove existing core dump configuration lines
    sed -i '/soft core/d' "$LIMITS_CONFIG_FILE" 2>/dev/null
    sed -i '/hard core/d' "$LIMITS_CONFIG_FILE" 2>/dev/null

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set core dump option to no in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_core_dump.*/set_core_dump=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set core dump option to no"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check

    # Step 3: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix

    # Step 4: Check if limits.conf is not modified
    # Use regex to match any number of whitespace characters between * and soft/hard
    ! grep "^\*\s\+soft\s\+core" "$LIMITS_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "limits.conf should not contain soft core configuration when set to no"

    ! grep "^\*\s\+hard\s\+core" "$LIMITS_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "limits.conf should not contain hard core configuration when set to no"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi

    if [[ -f "${LIMITS_CONFIG_FILE}-bak" ]]; then
        \cp "${LIMITS_CONFIG_FILE}-bak" "$LIMITS_CONFIG_FILE"
    fi

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
