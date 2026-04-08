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
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   ssh_login_tmout test (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SSHD_CONFIG_FILE="/etc/ssh/sshd_config"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SSHD_CONFIG_FILE" && ! -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "$SSHD_CONFIG_FILE" "${SSHD_CONFIG_FILE}-bak"
        LOG_INFO "Backed up /etc/ssh/sshd_config"
    fi
    sed -i '/^ClientAliveInterval/d' "$SSHD_CONFIG_FILE"
    sed -i '/^ClientAliveCountMax/d' "$SSHD_CONFIG_FILE"
    LOG_INFO "Removed existing ClientAliveInterval and ClientAliveCountMax configurations"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set ssh_login_tmout=yes in secscanner.cfg
    sed -i 's/^ssh_login_tmout.*/ssh_login_tmout=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set ssh_login_tmout=yes"
    # Execute secscanner check level3 before fix
    secscanner check level3 > tmp && \mv tmp check
    grep -i "SSH login timeout" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    # Execute secscanner fix level3 and check sshd_config content
    secscanner fix level3 > tmp && \mv tmp fix
    # Check ClientAliveInterval and ClientAliveCountMax configurations
    grep -E "^ClientAliveInterval\s+900" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Step 3: ClientAliveInterval not set to 900"
    grep -E "^ClientAliveCountMax\s+0" "$SSHD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Step 3: ClientAliveCountMax not set to 0"
    # Debug: Show current SSH login timeout configurations
    LOG_INFO "Current SSH login timeout configurations:"
    grep -i "ClientAliveInterval\|ClientAliveCountMax" "$SSHD_CONFIG_FILE"
    # Execute secscanner check level3 and check output
    secscanner check level3 > tmp && \mv tmp check
    grep -i "ssh login timeout" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 4: OK message not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/ssh/sshd_config" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${SSHD_CONFIG_FILE}-bak" ]]; then
        \cp "${SSHD_CONFIG_FILE}-bak" "$SSHD_CONFIG_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

