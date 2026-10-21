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
# @Desc      :   Test usx2yloader command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools-firmware alsa-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    command -v usx2yloader
    CHECK_RESULT $? 0 0 "usx2yloader command not found"
    # Test usx2yloader shows banner
    usx2yloader 2>&1 | grep -i "usx2yloader\|US-X2Y"
    CHECK_RESULT $? 0 0 "usx2yloader banner check failed"
    # Test -h option
    usx2yloader -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "usx2yloader -h check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -u usb-device option
        usx2yloader -u 0 2>&1 | grep -i "usx2yloader\|US-X2Y"
        CHECK_RESULT $? 0 0 "usx2yloader -u usb-device option check failed"
        # Test -D device option
        usx2yloader -D /dev/snd/pcmCARD0DATAPTR 2>&1 | grep -i "usx2yloader\|US-X2Y"
        CHECK_RESULT $? 0 0 "usx2yloader -D device option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
