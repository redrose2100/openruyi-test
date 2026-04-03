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
# @Desc      :   set_prohibit_ctrlaltdel=no test
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
SYSTEMD_CONF_FILE="/etc/systemd/system.conf"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    if [[ -f "$SYSTEMD_CONF_FILE" && ! -f "${SYSTEMD_CONF_FILE}-bak" ]]; then
        \cp "$SYSTEMD_CONF_FILE" "${SYSTEMD_CONF_FILE}-bak"
        LOG_INFO "Backed up /etc/systemd/system.conf"
    fi
    sed -i '/^CtrlAltDelBurstAction/d' "$SYSTEMD_CONF_FILE"
    LOG_INFO "Removed existing CtrlAltDelBurstAction configuration"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_prohibit_ctrlaltdel=no in secscanner.cfg
    sed -i 's/^set_prohibit_ctrlaltdel.*/set_prohibit_ctrlaltdel=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_prohibit_ctrlaltdel=no"
    # Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    LOG_INFO "Step 2: Executed secscanner check before fix"
    # Execute secscanner fix basic and check systemd.conf content
    secscanner fix basic > tmp && \mv tmp fix
    # When set_prohibit_ctrlaltdel=no, CtrlAltDelBurstAction should not be added
    grep -E "^CtrlAltDelBurstAction" "$SYSTEMD_CONF_FILE"
    CHECK_RESULT $? 1 0 "Step 3: CtrlAltDelBurstAction should not be added"
    # Debug: Show current CtrlAltDelBurstAction configuration
    grep -i "CtrlAltDelBurstAction" "$SYSTEMD_CONF_FILE"
    # Execute secscanner check basic and check output
    secscanner check basic > tmp && \mv tmp check
    grep -i "system ctrlaltdel burst action" check
    CHECK_RESULT $? 0 0 "Step 4: system ctrlaltdel burst action check not found"
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
    if [[ -f "${SYSTEMD_CONF_FILE}-bak" ]]; then
        \cp "${SYSTEMD_CONF_FILE}-bak" "$SYSTEMD_CONF_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"

