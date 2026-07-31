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
# @Desc      :   Test ld10k1d command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    command -v ld10k1d
    CHECK_RESULT $? 0 0 "ld10k1d command not found"
    # Test ld10k1d shows start
    ld10k1d start | grep "Starting"
    CHECK_RESULT $? 0 0 "ld10k1d should show start"
    # Test ld10k1d shows stop
    ld10k1d stop | grep "ld10k1 not runing"
    CHECK_RESULT $? 0 0 "ld10k1d should show stop"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
