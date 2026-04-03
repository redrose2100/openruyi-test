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
# @Desc      :   set_rp_filter test
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
    # Set set_rp_filter=yes in secscanner.cfg
    sed -i 's/^set_rp_filter.*/set_rp_filter=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_rp_filter=yes"
    secscanner check basic > tmp && \mv tmp check
    grep -i "reverse path filtering" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    secscanner fix basic > tmp && \mv tmp fix
    grep -E "^net\.ipv4\.conf\.all\.rp_filter=1" "$SYSCTL_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Step 3: net.ipv4.conf.all.rp_filter not set to 1"
    grep -E "^net\.ipv4\.conf\.default\.rp_filter=1" "$SYSCTL_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Step 3: net.ipv4.conf.default.rp_filter not set to 1"
    # Check current rp_filter values
    sysctl -n net.ipv4.conf.all.rp_filter | grep -E "^1$"
    CHECK_RESULT $? 0 0 "Step 4: net.ipv4.conf.all.rp_filter value is not 1"
    sysctl -n net.ipv4.conf.default.rp_filter | grep -E "^1$"
    CHECK_RESULT $? 0 0 "Step 4: net.ipv4.conf.default.rp_filter value is not 1"
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i "/etc/sysctl.conf" restore | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 5: Restore message not found"
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

