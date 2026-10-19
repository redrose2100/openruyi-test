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
# @Desc      :   set_tftp test (set to yes, level3)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    # Check if secScanner is installed
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install tftp if not installed
    DNF_INSTALL "tftp"
    # Check if tftp is installed
    rpm -qa | grep -w "tftp"
    CHECK_RESULT $? 0 0 "tftp should be installed"
    # Backup configuration files
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Step 1: Set set_tftp=yes in secscanner.cfg
    sed -i 's/^remove_tftp.*/remove_tftp=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set remove_tftp=yes"
    # Step 2: Check if tftp is installed
    rpm -qa | grep -w "tftp"
    CHECK_RESULT $? 0 0 "Step 2: tftp should be installed"
    # Step 3: Execute secscanner check level3 (fix前先check)
    secscanner check level3 > tmp && \mv tmp check
    # Step 4: Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check fix message
    grep -i "removed tftp" fix | grep -i "finished"
    CHECK_RESULT $? 0 0 "Step 4: Fix message not found"
    # Step 5: Check if tftp is uninstalled
    rpm -qa | grep -w "tftp"
    CHECK_RESULT $? 1 0 "Step 5: tftp should be uninstalled"
    # Step 6: Execute secscanner restore all (测试完要restore)
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    # Restore original files
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    # Remove installed packages
    DNF_REMOVE "$@"
    # Clean up temporary files
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"