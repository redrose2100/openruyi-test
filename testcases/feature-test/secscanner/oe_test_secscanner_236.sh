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
# @Date      :   2026-4-16
# @License   :   Mulan PSL v2
# @Desc      :   set_remove_python2 test (set to yes, python2 not installed, euler)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    # Check if python2 package is actually available
    python2_available=$(yum list python2 2>/dev/null | grep -c -E '^python2\.')
    if [ "$python2_available" -gt 0 ]; then
        # Try to install python2 if available
        DNF_INSTALL "python2" || exit 0
    else
        LOG_INFO "Python2 package not available, skipping test"
        exit 0
    fi
    DNF_INSTALL "secScanner"
    DNF_REMOVE 1 "python2"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Backing up secscanner.cfg"
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    sed -i 's/^set_remove_python2.*/set_remove_python2=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_remove_python2=yes"
    LOG_INFO "Checking if python2 is not installed before fix:"
    rpm -qa | grep -w "python2"
    CHECK_RESULT $? 1 0 "Python2 should not be installed before fix"
    LOG_INFO "Executing secscanner check euler"
    secscanner check euler > tmp && \mv tmp check
    LOG_INFO "Executing secscanner fix euler"
    secscanner fix euler > tmp && \mv tmp fix
    LOG_INFO "Checking if python2 is still not installed after fix:"
    rpm -qa | grep -w "python2"
    CHECK_RESULT $? 1 0 "Python2 should still not be installed after fix"
    LOG_INFO "Executing secscanner restore all"
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Restoring secscanner.cfg from backup"
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
