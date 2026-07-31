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
# @Desc      :   Test ld10k1 command parameters
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
    command -v ld10k1
    CHECK_RESULT $? 0 0 "ld10k1 command not found"
    # Test -h option
    ld10k1 -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "ld10k1 -h check failed"
    # Test --help option
    ld10k1 --help 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "ld10k1 --help check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -c card option
        ld10k1 -c 0 2>&1 | grep -i "emu10k1x\|card"
        CHECK_RESULT $? 0 0 "ld10k1 -c card option check failed"
        # Test -p pipe_name option
        ld10k1 -p /tmp/.ld10k1_test_port 2>&1 | grep -i "emu10k1x\|pipe"
        CHECK_RESULT $? 0 0 "ld10k1 -p pipe_name option check failed"
        # Test -t tram_size option
        ld10k1 -t 1024 2>&1 | grep -i "emu10k1x\|tram"
        CHECK_RESULT $? 0 0 "ld10k1 -t tram_size option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
