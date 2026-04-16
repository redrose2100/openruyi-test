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
# @Date      :   2026-4-16
# @License   :   Mulan PSL v2
# @Desc      :   set_remove_telnet test (set to yes, telnet already installed, euler)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner telnet"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Backing up secscanner.cfg"
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    # Set set_remove_telnet=yes in secscanner.cfg
    sed -i 's/^set_remove_telnet.*/set_remove_telnet=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_remove_telnet=yes"
    # Check if telnet is installed before fix
    LOG_INFO "Checking if telnet is installed before fix:"
    rpm -qa | grep -w "telnet"
    CHECK_RESULT $? 0 0 "Telnet should be installed before fix"
    # Execute secscanner check euler
    LOG_INFO "Executing secscanner check euler"
    secscanner check euler > tmp && \mv tmp check
    # Execute secscanner fix euler
    LOG_INFO "Executing secscanner fix euler"
    secscanner fix euler > tmp && \mv tmp fix
    # Check if telnet is removed after fix
    LOG_INFO "Checking if telnet is removed after fix:"
    rpm -qa | grep -w "telnet"
    CHECK_RESULT $? 1 0 "Telnet should be removed after fix"
    LOG_INFO "Currently this test failed，need to fix it"
    # Execute secscanner restore all
    LOG_INFO "Executing secscanner restore all"
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Restoring secscanner.cfg from backup"
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
