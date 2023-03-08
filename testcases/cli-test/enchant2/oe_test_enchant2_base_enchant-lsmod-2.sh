#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   GaoNan ZhouZhenBin WuXiChuan
# @Contact   :   690895849@qq.com
# @Date      :   2022/10/02
# @License   :   Mulan PSL v2
# @Desc      :   TEST enchant-lsmod-2
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "enchant2"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    enchant-lsmod-2 -help 2>&1 | grep "language_tag"
    CHECK_RESULT $? 0 0 "option: -help error"
    enchant-lsmod-2 -version 2>&1 | grepE "[0-9.]+$"
    CHECK_RESULT $? 0 0 "option: -version error"
    enchant-lsmod-2 -list-dicts | grepE "[a-zA-Z_]+ (.*)"
    CHECK_RESULT $? 0 0 "option: -list-dicts error"
    enchant-lsmod-2 -lang en_AU | grep "en_AU"
    CHECK_RESULT $? 0 0 "option: -lang error"
    enchant-lsmod-2 -word-chars en_AU | grep "0123456789"
    CHECK_RESULT $? 0 0 "option: -word-chars error"
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"