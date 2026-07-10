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
# @Desc      :   deny_root_login test with PermitRootLogin=yes
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

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
    
    if [[ -f "$SSHD_CONFIG_FILE" && ! -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}-bak"
    fi

    # Set PermitRootLogin=yes
    sed -i '/^PermitRootLogin/d' "$SSHD_CONFIG_FILE" 2>/dev/null
    echo "PermitRootLogin yes" >> "$SSHD_CONFIG_FILE"

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Set deny_root_login=yes in secscanner.cfg
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^deny_root_login.*/deny_root_login=yes/' "$CONFIG_FILE"

    # Step 1: Check current status with PermitRootLogin=yes
    secscanner check basic > tmp && \mv tmp check
    grep -i "ssh Root deni" check | grep WARNING
    CHECK_RESULT $? 0 0 "Root login WARNING check failed with PermitRootLogin=yes"

    # Step 2: Fix the configuration
    secscanner fix basic > tmp && \mv tmp fix
    grep -i "ssh root deny" fix | grep FINISHED
    CHECK_RESULT $? 0 0 "Root login fix failed with PermitRootLogin=yes"

    # Step 3: Verify the fix
    grep "PermitRootLogin no" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "PermitRootLogin not set to no after fix"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "${SSHD_CONFIG_FILE}-bak" "$SSHD_CONFIG_FILE"
    fi
    systemctl restart sshd 2>/dev/null
    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
