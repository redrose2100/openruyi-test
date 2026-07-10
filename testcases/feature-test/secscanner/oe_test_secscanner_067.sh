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
# @Desc      :   set_ssh_syslogfacility=no test
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

    # Backup sshd_config file
    if [[ -f "$SSHD_CONFIG_FILE" && ! -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}-bak"
        LOG_INFO "Backed up /etc/ssh/sshd_config"
    fi

    # Set SyslogFacility to AUTHPRIV for testing
    sed -i '/^SyslogFacility/d' "$SSHD_CONFIG_FILE"
    echo "SyslogFacility AUTHPRIV" >> "$SSHD_CONFIG_FILE"
    LOG_INFO "Set SyslogFacility to AUTHPRIV for testing"

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set set_ssh_syslogfacility=no in secscanner.cfg
    sed -i 's/^set_ssh_syslogfacility.*/set_ssh_syslogfacility=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_ssh_syslogfacility=no"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"

    # Step 3: Execute secscanner fix basic and check sshd_config content
    secscanner fix basic > tmp && \mv tmp fix
    # When set_ssh_syslogfacility=no, SyslogFacility should remain AUTHPRIV
    grep -E "^SyslogFacility AUTHPRIV" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Step 3: SyslogFacility should remain AUTHPRIV"
    secscanner restore all -y > tmp && \mv tmp restore

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

    # Remove installed packages
    DNF_REMOVE

    # Clean up temporary files
    rm -f fix check restore tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
