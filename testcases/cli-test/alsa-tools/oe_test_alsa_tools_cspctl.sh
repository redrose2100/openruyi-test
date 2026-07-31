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
# @Desc      :   Test cspctl command parameters
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
    command -v cspctl
    CHECK_RESULT $? 0 0 "cspctl command not found"
    # Test -h option
    cspctl -h 2>&1  | grep -i "usage"
    CHECK_RESULT $? 0 0 "cspctl -h check failed"
    # Test --help option
    cspctl --help 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "cspctl --help check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -c card option
        cspctl -c 0  | grep -iE "card|0"
        CHECK_RESULT $? 0 0 "cspctl -c card option check failed"
        # Test -f function option
        cspctl -f 1  | grep -iE "function|1"
        CHECK_RESULT $? 0 0 "cspctl -f function option check failed"
        # Test -d description option
        cspctl -d "test"  | grep -i "test"
        CHECK_RESULT $? 0 0 "cspctl -d description option check failed"
        # Test load command
        cspctl load  | grep -i "load"
        CHECK_RESULT $? 0 0 "cspctl load command check failed"
        # Test unload command
        cspctl unload  | grep -i "unload"
        CHECK_RESULT $? 0 0 "cspctl unload command check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
