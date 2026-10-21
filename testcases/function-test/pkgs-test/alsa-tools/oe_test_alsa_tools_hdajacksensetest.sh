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
# @Desc      :   Test hdajacksensetest command parameters
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
    command -v hdajacksensetest
    CHECK_RESULT $? 0 0 "hdajacksensetest command not found"
    # Test -h option
    hdajacksensetest -h | grep -i "usage"
    CHECK_RESULT $? 0 0 "hdajacksensetest -h check failed"
    # Test --help option
    hdajacksensetest --help | grep -i "usage"
    CHECK_RESULT $? 0 0 "hdajacksensetest --help check failed"
    # Test -c card option
    if aplay -l 2>/dev/null | grep -q "^card"; then
        hdajacksensetest -c 0 | grep -iE "codec|0"
        CHECK_RESULT $? 0 0 "hdajacksensetest -c card option check failed"
        # Test -d codec option
        hdajacksensetest -d 0 | grep -iE "codec|0"
        CHECK_RESULT $? 0 0 "hdajacksensetest -d codec option check failed"
        # Test -a allpins option
        hdajacksensetest -a | grep -i "pin"
        CHECK_RESULT $? 0 0 "hdajacksensetest -a allpins option check failed"
        # Test -s setpinsense option
        hdajacksensetest -s | grep -iE "set|pin"
        CHECK_RESULT $? 0 0 "hdajacksensetest -s setpinsense option check failed"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
