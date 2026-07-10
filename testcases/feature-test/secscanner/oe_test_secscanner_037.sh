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
# @Desc      :   Log recording test - login events, kernel warn, error events, auth events
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration and file list
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
RSYSLOG_CONFIG_FILE="/etc/rsyslog.conf"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    
    if [[ -f "$RSYSLOG_CONFIG_FILE" && ! -f "${RSYSLOG_CONFIG_FILE}-bak" ]]; then
        \cp "$RSYSLOG_CONFIG_FILE" "${RSYSLOG_CONFIG_FILE}-bak"
    fi

    # Record original rsyslog.conf content
    cat "$RSYSLOG_CONFIG_FILE" > rsyslog_original.txt

    # Remove existing log configuration lines
    sed -i '/^authpriv\.info/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^kern\.warning/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^\*\.err/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^auth\.none/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null

    # Do not remove log files as requested

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set log recording options to yes in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^recording_login_events.*/recording_login_events=yes/' "$CONFIG_FILE"
    sed -i 's/^recording_kernel_warn.*/recording_kernel_warn=yes/' "$CONFIG_FILE"
    sed -i 's/^recording_error_events.*/recording_error_events=yes/' "$CONFIG_FILE"
    sed -i 's/^recording_auth_events.*/recording_auth_events=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set log recording options"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    
    # Check for warning messages before fix
    grep -i "authpriv\.info" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output should show WARNING for authpriv.info before fix"
    
    grep -i "kern\.warn" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output should show WARNING for kern.warn before fix"
    
    grep -i "\*\.err" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output should show WARNING for *.err before fix"
    
    grep -i "auth\.none" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output should show WARNING for auth.none before fix"

    # Step 3: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    
    # Step 4: Check if rsyslog.conf contains the expected configuration
    grep "^authpriv\.info /var/log/authpriv\.log" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing authpriv.info configuration"
    
    grep "^kern\.warning /var/log/kern\.log" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing kern.warning configuration"
    
    grep "^\*\.err /var/log/errors\.log" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing *.err configuration"
    
    grep "^auth\.none /var/log/auth\.log" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing auth.none configuration"

    # Step 6: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep "$RSYSLOG_CONFIG_FILE" restore | grep FINISHED
    CHECK_RESULT $? 0 0 "Restore output missing for $RSYSLOG_CONFIG_FILE"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${RSYSLOG_CONFIG_FILE}-bak" ]]; then
        \cp "${RSYSLOG_CONFIG_FILE}-bak" "$RSYSLOG_CONFIG_FILE"
    fi

    # Clean up temporary files
    rm -f restore fix check tmp rsyslog_original.txt

    # Restart rsyslog service to apply changes
    systemctl restart rsyslog 2>/dev/null

    LOG_INFO "End to restore the test environment."
}

main "$@"
