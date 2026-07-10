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
# @Date      :   2026-2-27
# @License   :   Mulan PSL v2
# @Desc      :   set_passComplex fix
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 0
    DNF_INSTALL "secScanner"
    \cp /etc/pam.d/system-auth /etc/pam.d/system-auth-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    CONFIG_FILE="/etc/secScanner/secscanner.cfg"
    \cp "$CONFIG_FILE" "${CONFIG_FILE}_bak"
    sed -i 's/^set_passComplex.*/set_passComplex=yes/' "$CONFIG_FILE"
    sed -i '/requisite[[:space:]]\+pam_pwquality\.so/d' /etc/pam.d/system-auth
    
    secscanner check basic > tmp && \mv tmp check
    secscanner fix basic > tmp && \mv tmp fix
    grep -i "password complex" fix |grep FINISHED
    CHECK_RESULT $? 0 0
    grep "retry=3" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "difok=3" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "minclass=4" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "minlen=10" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "ucredit=-1" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "lcredit=-1" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "dcredit=-1" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    grep "ocredit=-1" /etc/pam.d/system-auth
    CHECK_RESULT $? 0 0
    
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i system-auth restore |grep FINISHED
    CHECK_RESULT $? 0 0
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    \mv /etc/pam.d/system-auth-bak /etc/pam.d/system-auth
    \mv "${CONFIG_FILE}_bak" "$CONFIG_FILE" 
    rm -f restore fix check "${CONFIG_FILE}_bak"
    LOG_INFO "End to restore the test environment."
}

main "$@"