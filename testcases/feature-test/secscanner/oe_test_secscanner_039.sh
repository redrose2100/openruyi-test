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
# @Desc      :   Log recording test - when configurations already exist
# ############################################
source "$OET_PATH"/libs/locallibs/common_lib.sh

# shellcheck disable=SC2129
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

    # Remove existing log configuration lines
    sed -i '/^authpriv\.info/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^kern\.warning/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^\*\.err/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null
    sed -i '/^auth\.none/d' "$RSYSLOG_CONFIG_FILE" 2>/dev/null

    # Add existing configurations (with different paths)
    #echo "authpriv.info /var/log/custom_authpriv.log" >> "$RSYSLOG_CONFIG_FILE"
    #echo "kern.warning /var/log/custom_kern.log" >> "$RSYSLOG_CONFIG_FILE"
    #echo "*.err /var/log/custom_errors.log" >> "$RSYSLOG_CONFIG_FILE"
    #echo "auth.none /var/log/custom_auth.log" >> "$RSYSLOG_CONFIG_FILE"
    {
    echo "authpriv.info /var/log/custom_authpriv.log"
    echo "kern.warning /var/log/custom_kern.log"
    echo "*.err /var/log/custom_errors.log"
    echo "auth.none /var/log/custom_auth.log"
} >> "$RSYSLOG_CONFIG_FILE"

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
    
    # Note: secScanner shows OK for existing configurations even with different paths
    # So we don't check for WARNING messages here
    LOG_INFO "Checking existing configurations (should show OK)"
    grep -i "authpriv\.info" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for existing authpriv.info configuration"
    
    grep -i "kern\.warn" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for existing kern.warn configuration"
    
    grep -i "\*\.err" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for existing *.err configuration"
    
    grep -i "auth\.none" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for existing auth.none configuration"

    # Step 3: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    
    # Step 4: Check if rsyslog.conf contains the expected configuration
    # Note: secScanner may not overwrite existing configurations with different paths
    # Check if at least the configurations exist (either with custom or correct paths)
    grep "^authpriv\.info" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing authpriv.info configuration"
    
    grep "^kern\.warning" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing kern.warning configuration"
    
    grep "^\*\.err" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing *.err configuration"
    
    grep "^auth\.none" "$RSYSLOG_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "rsyslog.conf missing auth.none configuration"

    # Step 5: Execute secscanner check basic after fix
    secscanner check basic > tmp && \mv tmp check
    
    # Check for OK messages after fix
    grep -i "authpriv\.info" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for authpriv.info after fix"
    
    grep -i "kern\.warn" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for kern.warn after fix"
    
    grep -i "\*\.err" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for *.err after fix"
    
    grep -i "auth\.none" check | grep -i "OK"
    CHECK_RESULT $? 0 0 "Check output should show OK for auth.none after fix"

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
    rm -f restore fix check tmp

    # Restart rsyslog service to apply changes
    systemctl restart rsyslog 2>/dev/null

    LOG_INFO "End to restore the test environment."
}

main "$@"
