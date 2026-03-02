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
# @Date      :   2026-2-28
# @License   :   Mulan PSL v2
# @Desc      :   lock_attacking_user check if unlock_time not set
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"
    \cp /etc/pam.d/system-auth /etc/pam.d/system-auth-bak
    \cp /etc/pam.d/password-auth /etc/pam.d/password-auth-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    CONFIG_FILE="/etc/secScanner/secscanner.cfg"
    \cp "$CONFIG_FILE" "${CONFIG_FILE}_bak"
    sed -i 's/^lock_attacking_user.*/lock_attacking_user=yes/' "$CONFIG_FILE"
    sed -i '/unlock_time/d' /etc/pam.d/system-auth
    sed -i '/unlock_time/d' /etc/pam.d/password-auth
    secscanner check basic > tmp && \mv tmp check
    grep -i "login lock Deny" check |grep WARNING
    secscanner fix basic > tmp && \mv tmp fix
    grep -i "Set user login lock" fix |grep FINISHED
    grep "unlock_time=300" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "unlock_time=300" /etc/pam.d/password-auth
    CHECK_RESULT $? 0 0
    
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i system-auth restore |grep FINISHED
    CHECK_RESULT $? 0 0
    grep -i password-auth restore |grep FINISHED
    CHECK_RESULT $? 0 0
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    \mv /etc/pam.d/system-auth-bak /etc/pam.d/system-auth
    \mv /etc/pam.d/password-auth-bak /etc/pam.d/password-auth
    \mv "${CONFIG_FILE}_bak" "$CONFIG_FILE" 
    rm -f restore fix check "${CONFIG_FILE}_bak"
    LOG_INFO "End to restore the test environment."
}

main "$@"