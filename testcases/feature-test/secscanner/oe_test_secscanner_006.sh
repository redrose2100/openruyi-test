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
# @Desc      :   set_motd check
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    yum search secScanner || exit 255
    DNF_INSTALL "secScanner"
    \cp /etc/motd ./motd_bak
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    CONFIG_FILE="/etc/secScanner/secscanner.cfg"
    \cp "$CONFIG_FILE" "${CONFIG_FILE}_bak"
    sed -i 's/^set_motd=.*/set_motd=yes/' "$CONFIG_FILE"
    >/etc/motd
    secscanner check basic > check
    grep WARNING check | grep motd
    CHECK_RESULT $? 0 0
    secscanner fix basic > fix
    grep motd fix |grep FINISHED
    CHECK_RESULT $? 0 0
    secscanner restore all -y >restore
    grep motd restore |grep FINISHED
    CHECK_RESULT $? 0 0
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    \cp ./motd_bak /etc/motd
    \cp "${CONFIG_FILE}_bak" "$CONFIG_FILE" 
    rm -f restore fix check motd_bak "${CONFIG_FILE}_bak"
    LOG_INFO "End to restore the test environment."
}

main "$@"