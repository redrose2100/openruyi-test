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
# @Date      :   2026-2-28
# @License   :   Mulan PSL v2
# @Desc      :   disable_icmp_redirect check if net.ipv4.conf.all.accept_redirects not set
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"
    \cp /etc/sysctl.conf sysctl.conf-bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    CONFIG_FILE="/etc/secScanner/secscanner.cfg"
    \cp "$CONFIG_FILE" "${CONFIG_FILE}_bak"
    sed -i 's/^disable_icmp_redirect.*/disable_icmp_redirect=yes/' "$CONFIG_FILE"
    sed -i '/net.ipv4.conf.all.accept_redirects/d' /etc/sysctl.conf 
    secscanner check basic > tmp && \mv tmp check
    grep -i "icmp" check |grep WARNING
    secscanner fix basic > tmp && \mv tmp fix
    grep -i "icmp" fix |grep FINISHED
    grep net.ipv4.conf.all.accept_redirects=0 /etc/sysctl.conf 
    CHECK_RESULT $? 0 0
    
    secscanner restore all -y > tmp && \mv tmp restore
    grep -i sysctl.conf restore |grep FINISHED
    CHECK_RESULT $? 0 0 
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    \mv sysctl.conf-bak /etc/sysctl.conf
    \mv "${CONFIG_FILE}_bak" "$CONFIG_FILE" 
    rm -f restore fix check "${CONFIG_FILE}_bak"
    LOG_INFO "End to restore the test environment."
}

main "$@"