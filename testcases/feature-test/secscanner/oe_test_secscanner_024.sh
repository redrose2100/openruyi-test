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
# @Date      :   2026-3-26
# @License   :   Mulan PSL v2
# @Desc      :   SSH login banner test - basic functionality
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"
SSH_BANNER_FILE="/etc/sshbanner"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Backup sshd_config file if it exists
    if [[ -f "$SSHD_CONFIG_FILE" && ! -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}-bak"
    fi
    
    # Always modify configuration regardless of backup status
    if [[ -f "$SSHD_CONFIG_FILE" ]]; then
        # Remove any existing Banner configuration
        sed -i '/^Banner/d' "$SSHD_CONFIG_FILE" 2>/dev/null
    fi

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_ssh_login_banner=yes in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_ssh_login_banner.*/set_ssh_login_banner=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_ssh_login_banner=yes"

    # Step 2: Execute secscanner fix basic
    secscanner check basic > tmp && \mv tmp check
    # Check for WARNING about no ssh banner config
    grep -i "banner" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output missing WARNING about no ssh banner config"

    # Step 3: Execute secscanner fix basic again
    secscanner fix basic > tmp && \mv tmp fix

    # Step 4: Verify sshd_config contains Banner configuration
    grep "^Banner" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "sshd_config missing Banner /etc/sshbanner"

    # Step 5: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep "$SSHD_CONFIG_FILE" restore | grep FINISHED
    CHECK_RESULT $? 0 0 "Restore output missing for $SSHD_CONFIG_FILE"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original sshd_config file from backup
    if [[ -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "${SSHD_CONFIG_FILE}-bak" "${SSHD_CONFIG_FILE}"
    fi

    # Remove ssh banner file if created
    [[ -f "$SSH_BANNER_FILE" ]] && rm -f "$SSH_BANNER_FILE"

    # Restore secScanner configuration and remove package
    [[ -f "${CONFIG_FILE}-bak" ]] && \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
