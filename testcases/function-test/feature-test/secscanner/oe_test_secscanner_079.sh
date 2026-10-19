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
# @Date      :   2026-4-1
# @License   :   Mulan PSL v2
# @Desc      :   set_kernel_oops=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SYSCTL_CONFIG_FILE="/etc/sysctl.conf"
RC_LOCAL_SERVICE="/lib/systemd/system/rc-local.service"
RC_LOCAL_FILE="/etc/rc.local"
RC_D_LOCAL_FILE="/etc/rc.d/rc.local"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SYSCTL_CONFIG_FILE" && ! -f "${SYSCTL_CONFIG_FILE}-bak" ]]; then
        \cp "$SYSCTL_CONFIG_FILE" "${SYSCTL_CONFIG_FILE}-bak"
        LOG_INFO "Backed up /etc/sysctl.conf"
    fi
    if [[ -f "$RC_LOCAL_SERVICE" && ! -f "${RC_LOCAL_SERVICE}-bak" ]]; then
        \cp "$RC_LOCAL_SERVICE" "${RC_LOCAL_SERVICE}-bak"
        LOG_INFO "Backed up /lib/systemd/system/rc-local.service"
    fi
    if [[ -f "$RC_LOCAL_FILE" && ! -f "${RC_LOCAL_FILE}-bak" ]]; then
        \cp "$RC_LOCAL_FILE" "${RC_LOCAL_FILE}-bak"
        LOG_INFO "Backed up /etc/rc.local"
    fi
    if [[ -f "$RC_D_LOCAL_FILE" && ! -f "${RC_D_LOCAL_FILE}-bak" ]]; then
        \cp "$RC_D_LOCAL_FILE" "${RC_D_LOCAL_FILE}-bak"
        LOG_INFO "Backed up /etc/rc.d/rc.local"
    fi
    sed -i '/^kernel\.panic_on_oops/d' "$SYSCTL_CONFIG_FILE"
    LOG_INFO "Removed existing kernel.panic_on_oops configuration"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_kernel_oops=no in secscanner.cfg
    sed -i 's/^set_kernel_oops.*/set_kernel_oops=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_kernel_oops=no"
    # Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"
    # Execute secscanner fix basic and check configurations
    secscanner fix basic > tmp && \mv tmp fix
    # When set_kernel_oops=no, kernel.panic_on_oops should not be added
    grep -E "^kernel\.panic_on_oops" "$SYSCTL_CONFIG_FILE"
    CHECK_RESULT $? 1 0 "Step 3: kernel.panic_on_oops should not be added"
    # Debug: Show current configurations
    LOG_INFO "Current kernel.panic_on_oops configuration:"
    grep -i "kernel.panic_on_oops" "$SYSCTL_CONFIG_FILE"
    # Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "kernel panic on oops" check
    CHECK_RESULT $? 0 0 "Step 4: kernel panic on oops check not found"
    # Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "Step 5: Executed secscanner restore all"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    if [[ -f "${SYSCTL_CONFIG_FILE}-bak" ]]; then
        \cp "${SYSCTL_CONFIG_FILE}-bak" "$SYSCTL_CONFIG_FILE"
    fi
    if [[ -f "${RC_LOCAL_SERVICE}-bak" ]]; then
        \cp "${RC_LOCAL_SERVICE}-bak" "$RC_LOCAL_SERVICE"
    fi
    if [[ -f "${RC_LOCAL_FILE}-bak" ]]; then
        \cp "${RC_LOCAL_FILE}-bak" "$RC_LOCAL_FILE"
    fi
    if [[ -f "${RC_D_LOCAL_FILE}-bak" ]]; then
        \cp "${RC_D_LOCAL_FILE}-bak" "$RC_D_LOCAL_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

