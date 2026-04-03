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
# @Date      :   2026-4-3
# @License   :   Mulan PSL v2
# @Desc      :   remove_tftp test (set to yes)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install tftp if not installed
    yum search tftp || exit 0
    DNF_INSTALL "tftp"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Check if tftp is installed
    rpm -qa | grep -w tftp
    CHECK_RESULT $? 0 0 "tftp should be installed"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    sed -i 's/^remove_tftp.*/remove_tftp=yes/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set remove_tftp=yes"
    rpm -qa | grep -w tftp
    CHECK_RESULT $? 0 0 "tftp should be installed"
    secscanner check level3 > tmp && \mv tmp check
    secscanner fix level3 > tmp && \mv tmp fix
    grep -i "remove.*tftp" fix | grep -i "finished"
    if [ $? -ne 0 ]; then
        LOG_INFO "Fix output:"
        cat fix
        CHECK_RESULT 1 0 0 "Remove tftp message not found"
    fi
    rpm -qa | grep -w tftp
    CHECK_RESULT $? 1 0 "tftp should be uninstalled"
    secscanner restore all -y > tmp && \mv tmp restore
    LOG_INFO "All checks finished."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    if [[ -f "${CONFIG_FILE}-bak" ]]; then
        \cp "${CONFIG_FILE}-bak" "$CONFIG_FILE"
    fi
    DNF_REMOVE "$@"
    rm -f fix check restore tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"