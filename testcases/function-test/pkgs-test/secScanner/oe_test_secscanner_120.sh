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
# @Desc      :   deny_root_login test (set to no)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SSHD_CONFIG="/etc/ssh/sshd_config"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SSHD_CONFIG" && ! -f "${SSHD_CONFIG}-bak" ]]; then
        \cp "$SSHD_CONFIG" "${SSHD_CONFIG}-bak"
    fi
    # Set PermitRootLogin to yes
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^deny_root_login.*/deny_root_login=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set deny_root_login=no"
    secscanner check basic > tmp && \mv tmp check
    # Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    # Check if PermitRootLogin remains yes
    grep -E "^PermitRootLogin yes" "$SSHD_CONFIG"
    CHECK_RESULT $? 0 0 "PermitRootLogin should remain yes when deny_root_login=no"
    # Check restore
    secscanner restore all -y > tmp && \mv tmp restore
    # Restore original configuration
    if [[ -f "${SSHD_CONFIG}-bak" ]]; then
        \cp "${SSHD_CONFIG}-bak" "$SSHD_CONFIG"
    fi
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${SSHD_CONFIG}-bak" ]]; then
        \cp "${SSHD_CONFIG}-bak" "$SSHD_CONFIG"
        rm -f "${SSHD_CONFIG}-bak"
    fi
    systemctl restart sshd
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
