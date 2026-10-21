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
# @Date      :   2026-4-15
# @License   :   Mulan PSL v2
# @Desc      :   set_link_protection test (set to yes, symlink disabled, hardlink enabled, euler)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Set symlink protection to 0, hardlink to 1
    sysctl -w fs.protected_symlinks=0 > /dev/null 2>&1
    sysctl -w fs.protected_hardlinks=1 > /dev/null 2>&1
    # Verify protection settings
    sysctl fs.protected_symlinks
    sysctl fs.protected_hardlinks
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_link_protection=yes in secscanner.cfg
    sed -i 's/^set_link_protection.*/set_link_protection=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_link_protection=yes"
    # Check if symlink is disabled and hardlink is enabled before fix
    SYMLINK_STATUS=$(sysctl -n fs.protected_symlinks)
    HARDlink_STATUS=$(sysctl -n fs.protected_hardlinks)
    CHECK_RESULT "$SYMLINK_STATUS" "0" 0 "Symlink protection should be disabled before fix"
    CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled before fix"
    # Execute secscanner check euler
    secscanner check euler > tmp && \mv tmp check
    # Execute secscanner fix euler
    secscanner fix euler > tmp && \mv tmp fix
    # Check if both protections are enabled after fix
    SYMLINK_STATUS=$(sysctl -n fs.protected_symlinks)
    HARDlink_STATUS=$(sysctl -n fs.protected_hardlinks)
    CHECK_RESULT "$SYMLINK_STATUS" "1" 0 "Symlink protection should be enabled after fix"
    CHECK_RESULT "$HARDlink_STATUS" "1" 0 "Hardlink protection should be enabled after fix"
    # Execute secscanner restore all
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
        rm -f "${CONFIG_FILE}-bak"
    fi
    # Restore protection settings
    sysctl -w fs.protected_symlinks=0 > /dev/null 2>&1
    sysctl -w fs.protected_hardlinks=1 > /dev/null 2>&1
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
