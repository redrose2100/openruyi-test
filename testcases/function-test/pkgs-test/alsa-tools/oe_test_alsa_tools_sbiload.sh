#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/29
# @License   :   Mulan PSL v2
# @Desc      :   Test sbiload command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools alsa-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test --help option
    sbiload --help 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "sbiload --help check failed"
    # Test -V version option
    sbiload -V 2>&1 | grep -i "version"
    CHECK_RESULT $? 0 0 "sbiload -V version check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -c clear option
        sbiload -c 2>&1 | grep -i "patches\|clear"
        CHECK_RESULT $? 0 0 "sbiload -c clear option check failed"
        # Test -D device option
        sbiload -D /dev/snd/pcmCARD0DATAPTR 2>&1 | grep -i "sbiload\|device"
        CHECK_RESULT $? 0 0 "sbiload -D device option check failed"
        # Test -2 opl2 option
        sbiload -2 2>&1 | grep -i "opl2"
        CHECK_RESULT $? 0 0 "sbiload -2 opl2 option check failed"
        # Test -4 opl3 option
        sbiload -4 2>&1 | grep -i "opl3"
        CHECK_RESULT $? 0 0 "sbiload -4 opl3 option check failed"
        # Test -P path option
        sbiload -P /tmp 2>&1 | grep -i "path"
        CHECK_RESULT $? 0 0 "sbiload -P path option check failed"
        # Test -v verbose option
        sbiload -v 1 2>&1 | grep -i "verbose"
        CHECK_RESULT $? 0 0 "sbiload -v verbose option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
