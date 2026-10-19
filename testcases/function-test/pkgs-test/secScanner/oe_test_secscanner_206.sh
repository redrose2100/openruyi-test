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
# @Desc      :   set_dovecot test (set to yes, dovecot service masked, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner dovecot"
    # Unmask dovecot service first
    systemctl unmask dovecot
    # Enable dovecot service
    systemctl enable dovecot
    # Mask dovecot service
    systemctl mask dovecot
    # Check if dovecot is masked
    systemctl is-enabled dovecot
    CHECK_RESULT $? 1 0 "dovecot should be masked"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_dovecot=yes in secscanner.cfg
    sed -i 's/^set_dovecot.*/set_dovecot=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_dovecot=yes"
    # Check if dovecot is masked before fix
    systemctl is-enabled dovecot
    CHECK_RESULT $? 1 0 "dovecot should be masked before fix"
    # Execute secscanner check level3
    secscanner check level3 > tmp && \mv tmp check
    # Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if dovecot is still masked after fix
    systemctl is-enabled dovecot
    CHECK_RESULT $? 1 0 "dovecot should be masked after fix"
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
    # Restore dovecot service
    systemctl unmask dovecot
    systemctl enable dovecot
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
