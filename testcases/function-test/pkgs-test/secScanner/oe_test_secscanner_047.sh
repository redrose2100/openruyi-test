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
# @Date      :   2026-3-27
# @License   :   Mulan PSL v2
# @Desc      :   FTP configuration test - restrict directory (chroot_local_user) when set to no
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

    # Remove existing chroot_local_user configuration line
    sed -i '/^chroot_local_user/d' "$VSFTPD_CONFIG_FILE" 2>/dev/null

    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."

    # Step 1: Set FTP restrict directory option to no in configuration
    \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    sed -i 's/^set_ftp_restrictdir.*/set_ftp_restrictdir=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set FTP restrict directory option to no"

    # Step 2: Execute secscanner check basic before fix
    secscanner check basic > tmp && \mv tmp check
    
    # Step 3: Execute secscanner fix basic
    secscanner fix basic > tmp && \mv tmp fix
    
    # Step 4: Check if vsftpd.conf is not modified
    ! grep "^chroot_local_user" "$VSFTPD_CONFIG_FILE"
    CHECK_RESULT $? 0 0 "vsftpd.conf should not contain chroot_local_user configuration when set to no"

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
