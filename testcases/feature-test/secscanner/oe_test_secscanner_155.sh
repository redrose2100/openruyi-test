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
# @Date      :   2026-4-13
# @License   :   Mulan PSL v2
# @Desc      :   set_rsyslog test (set to yes, service disabled, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

# Global variables
rsyslog_status=""

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install rsyslog if not installed
    DNF_INSTALL "rsyslog"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Check and record original rsyslog status
    rsyslog_status=$(systemctl is-enabled rsyslog 2>/dev/null || echo "disabled")
    # Disable rsyslog service
    systemctl disable rsyslog
    LOG_INFO "Original rsyslog status: $rsyslog_status"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_rsyslog=yes in secscanner.cfg
    sed -i 's/^set_rsyslog.*/set_rsyslog=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_rsyslog=yes"
    # Step 2: Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Check WARNING message
    grep -i "rsyslog.*service" check | grep -i "warning"
    CHECK_RESULT $? 0 0 "Step 2: WARNING message not found"
    # Step 3: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check fix message
    grep -i "rsyslog service enabled" fix | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 3: Fix message not found"
    # Step 4: Execute secscanner check level3 again
    secscanner check level3 > tmp && \mv tmp check
    # Check OK message
    grep -i "Has right rsyslog service set: enabled" check | grep -i "ok"
    CHECK_RESULT $? 0 0 "Step 4: OK message not found"
    # Step 5: Check if rsyslog is enabled
    systemctl is-enabled rsyslog
    CHECK_RESULT $? 0 0 "Step 5: rsyslog should be enabled"
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Restore original rsyslog status
    if [[ "$rsyslog_status" == "enabled" ]]; then
        systemctl enable rsyslog
        LOG_INFO "Restored rsyslog to enabled status"
    else
        systemctl disable rsyslog
        LOG_INFO "Restored rsyslog to disabled status"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"