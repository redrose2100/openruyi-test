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
# @Desc      :   SSH GSSAPI test - when set to no (should not modify sshd_config)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup sshd_config file if it exists
    if [[ -f "$SSHD_CONFIG_FILE" && ! -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}-bak"
    fi
    
    # Always modify configuration regardless of backup status
    if [[ -f "$SSHD_CONFIG_FILE" ]]; then
        # Set GSSAPIAuthentication to yes for testing
        sed -i '/^GSSAPIAuthentication/d' "$SSHD_CONFIG_FILE" 2>/dev/null
        echo "GSSAPIAuthentication yes" >> "$SSHD_CONFIG_FILE"
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_ssh_gssapi=no in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_ssh_gssapi.*/set_ssh_gssapi=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_ssh_gssapi=no"

    # Step 2: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix

    # Step 3: Verify sshd_config is NOT modified (GSSAPIAuthentication should remain yes)
    grep "^GSSAPIAuthentication yes" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "sshd_config should not be modified when set_ssh_gssapi=no"

    # Step 4: Execute secscanner restore all
    secscanner restore all -y > tmp && \mv tmp restore

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original sshd_config file from backup
    if [[ -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "${SSHD_CONFIG_FILE}-bak" "$SSHD_CONFIG_FILE"
    fi

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
