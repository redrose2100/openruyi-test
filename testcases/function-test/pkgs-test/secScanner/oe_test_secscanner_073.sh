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
# @Desc      :   set_rp_filter=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SYSCTL_CONFIG_FILE="/etc/sysctl.conf"

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
    sed -i '/^net\.ipv4\.conf\.all\.rp_filter/d' "$SYSCTL_CONFIG_FILE"
    sed -i '/^net\.ipv4\.conf\.default\.rp_filter/d' "$SYSCTL_CONFIG_FILE"
    LOG_INFO "Removed existing rp_filter configuration"
    sysctl -p > /dev/null 2>&1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_rp_filter=no in secscanner.cfg
    sed -i 's/^set_rp_filter.*/set_rp_filter=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_rp_filter=no"
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"
    secscanner fix basic > tmp && \mv tmp fix
    # When set_rp_filter=no, rp_filter configuration should not be added
    grep -E "^net\.ipv4\.conf\.all\.rp_filter" "$SYSCTL_CONFIG_FILE"
    CHECK_RESULT $? 1 0 "Step 3: net.ipv4.conf.all.rp_filter should not be added"
    grep -E "^net\.ipv4\.conf\.default\.rp_filter" "$SYSCTL_CONFIG_FILE"
    CHECK_RESULT $? 1 0 "Step 3: net.ipv4.conf.default.rp_filter should not be added"
    secscanner restore all -y > tmp && \mv tmp restore
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
    sysctl -p > /dev/null 2>&1
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

