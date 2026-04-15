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
# @Desc      :   set_samba test (set to yes, smb service already disabled, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner samba"
    # Unmask and disable smb service
    systemctl unmask smb
    systemctl disable smb
    # Check if smb is disabled
    systemctl is-enabled smb
    CHECK_RESULT $? 1 0 "smb should be disabled"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_samba=yes in secscanner.cfg
    sed -i 's/^set_samba.*/set_samba=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_samba=yes"
    # Check if smb is disabled before fix
    systemctl is-enabled smb
    CHECK_RESULT $? 1 0 "smb should be disabled before fix"
    # Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if smb is still disabled after fix
    systemctl is-enabled smb
    CHECK_RESULT $? 1 0 "smb should remain disabled when set_samba=yes"
    # Execute secscanner restore all
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "${CONFIG_FILE}"
    fi
    # Restore smb service
    systemctl unmask smb
    systemctl enable smb
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
