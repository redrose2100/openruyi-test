#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   caowenqian
#@Contact       :   caowenqian@uniontech.com
#@Date          :   2026-06-15
#@License       :   Mulan PSL v2
#@Desc          :   Test case for setterm command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."

    # Test setterm --help
    setterm --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --help execution"

    # Test setterm --version
    setterm --version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --version execution"

    # Test setterm --reset
    setterm --reset > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --reset execution"

    # Test setterm --initialize
    setterm --initialize > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --initialize execution"

    # Test setterm --default
    setterm --default > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --default execution"

    # Test setterm --resize
    setterm --resize > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "setterm --resize execution"

    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "End to restore the test environment."
}

main "$@"
