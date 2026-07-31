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
# @Desc      :   Test us428control command parameters
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
    # Test us428control shows version info
    us428control 2>&1 | grep -i "US-X2Y\|US-428\|version\|card"
    CHECK_RESULT $? 0 0 "us428control execution check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -v verbosity option
        us428control -v 0 2>&1 | grep -i "US-X2Y\|US-428"
        CHECK_RESULT $? 0 0 "us428control -v verbosity option check failed"
        # Test -c card option
        us428control -c 0 2>&1 | grep -i "US-X2Y\|US-428"
        CHECK_RESULT $? 0 0 "us428control -c card option check failed"
        # Test -D device option
        us428control -D /dev/snd/pcmCARD0 2>&1 | grep -i "US-X2Y\|US-428"
        CHECK_RESULT $? 0 0 "us428control -D device option check failed"
        # Test -u usb-device option
        us428control -u 0 2>&1 | grep -i "US-X2Y\|US-428"
        CHECK_RESULT $? 0 0 "us428control -u usb-device option check failed"
        # Test -m mode option with us224 mode
        us428control -m us224 2>&1 | grep -i "US-X2Y\|US-428"
        CHECK_RESULT $? 0 0 "us428control -m mode option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
