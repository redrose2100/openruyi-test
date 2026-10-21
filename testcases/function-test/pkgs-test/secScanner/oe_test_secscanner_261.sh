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
# @Desc      :   set_remove_ypbind test (set to no, ypbind installed, euler)
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

CONFIG_FILE="/etc/secScanner/secscanner.cfg"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner ypbind"
    if [[ -f "$CONFIG_FILE" && ! -f "${CONFIG_FILE}-bak" ]]; then
        LOG_INFO "Backing up secscanner.cfg"
        \cp "$CONFIG_FILE" "${CONFIG_FILE}-bak"
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    sed -i 's/^set_remove_ypbind.*/set_remove_ypbind=no/' "$CONFIG_FILE"
    CHECK_RESULT $? 0 0 "Failed to set set_remove_ypbind=no"
    LOG_INFO "Checking if ypbind is installed before fix:"
    rpm -qa | grep "ypbind"
    CHECK_RESULT $? 0 0 "ypbind should be installed before fix"
    secscanner check euler > tmp && \mv tmp check
    secscanner fix euler > tmp && \mv tmp fix
    LOG_INFO "Checking if ypbind is still installed after fix:"
    rpm -qa | grep "ypbind"
    CHECK_RESULT $? 0 0 "ypbind should still be installed after fix"

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
