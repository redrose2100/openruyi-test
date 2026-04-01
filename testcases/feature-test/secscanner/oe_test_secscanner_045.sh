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
# @Desc      :   FTP configuration test - banner (ftpd_banner) when set to yes
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration files
CONFIG_FILE="/etc/secScanner/secscanner.cfg"
VSFTPD_CONFIG_FILE="/etc/vsftpd/vsftpd.conf"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    # Check if secScanner is installed
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"

    # Install vsftpd if not installed
    if ! rpm -q vsftpd > /dev/null 2>&1; then
        DNF_INSTALL "vsftpd"
    fi

    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    
    if [[ -f "$VSFTPD_CONFIG_FILE" && ! -f "${VSFTPD_CONFIG_FILE}-bak" ]]; then
        \cp "$VSFTPD_CONFIG_FILE" "${VSFTPD_CONFIG_FILE}-bak"
    fi

    # Remove existing ftpd_banner configuration line
    sed -i '/^ftpd_banner/d' "$VSFTPD_CONFIG_FILE" 2>/dev/null

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set FTP banner option to yes in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_ftp_banner.*/set_ftp_banner=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set FTP banner option"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    
    # Check for warning messages before fix
    grep -i "ftp" check | grep -i "WARNING"
    CHECK_RESULT $? 0 0 "Check output should show WARNING for FTP before fix"

    # Step 3: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    
    # Step 4: Check if vsftpd.conf contains the expected configuration
    grep "^ftpd_banner=Authorized users only. All activity may be monitored and reported." "$VSFTPD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "vsftpd.conf missing ftpd_banner configuration"

    # Step 6: Execute secscanner restore all and check output
    secscanner restore all -y > tmp && \mv tmp restore
    grep "$VSFTPD_CONFIG_FILE" restore | grep FINISHED
    CHECK_RESULT $? 0 0 "Restore output missing for $VSFTPD_CONFIG_FILE"

    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    
    if [[ -f "${VSFTPD_CONFIG_FILE}-bak" ]]; then
        \cp "${VSFTPD_CONFIG_FILE}-bak" "$VSFTPD_CONFIG_FILE"
    fi

    # Remove installed packages
    DNF_REMOVE "$@"

    # Clean up temporary files
    rm -f restore fix check tmp

    LOG_INFO "End to restore the test environment."
}

main "$@"
