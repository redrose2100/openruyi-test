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
# @Date      :   2026-4-2
# @License   :   Mulan PSL v2
# @Desc      :   remove_http test (set to no)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

# Global configuration
CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    # Install httpd if not installed
    yum search httpd || exit 0
    DNF_INSTALL "httpd"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    # Check if httpd is installed
    rpm -qa | grep -w httpd
    CHECK_RESULT $? 0 0 "httpd should be installed"
    LOG_INFO "End of environmental preparation!"
}

function run_test() { 
    LOG_INFO "start to run test."
    # Set remove_http=no in secscanner.cfg
    sed -i 's/^remove_http.*/remove_http=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set remove_http=no"
    # Check if httpd is installed
    rpm -qa | grep -w httpd
    CHECK_RESULT $? 0 0 "Step 2: httpd should be installed"
    secscanner check level3 > tmp && \mv tmp check
    # Execute secscanner fix level3
    secscanner fix level3 > tmp && \mv tmp fix
    # Check if httpd is still installed
    rpm -qa | grep -w httpd
    CHECK_RESULT $? 0 0 "Step 3: httpd should remain installed"
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

