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
# @Author    :   songfurong
# @Contact   :   2597578239@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST mtx
# #############################################

source "common/common.sh"

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    common_config_params
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    # Introduce common function
    common_pre
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    # Introduce common function
    common_test
    # Test that the version information is correct
    mtx --version 2>&1 | grep "mtx version"
    CHECK_RESULT $? 0 0 "option: --version error"
    mtx -f ${PATH_MEDIUMX} noattach
    CHECK_RESULT $? 0 0 "option: -f noattach error"
    mtx -f ${PATH_MEDIUMX} inquiry | grep ${DRIVER_MEDIUMX}
    CHECK_RESULT $? 0 0 "option: -f inquiry error"
    mtx -f ${PATH_MEDIUMX} inventory
    CHECK_RESULT $? 0 0 "option: -f inventory error"
    mtx -f ${PATH_MEDIUMX} status | grep "Element"
    CHECK_RESULT $? 0 0 "option: -f status error"
    mtx -f ${PATH_MEDIUMX} first | grep "done"
    CHECK_RESULT $? 0 0 "option: -f first error"
    mtx -f ${PATH_MEDIUMX} last | grep "done"
    CHECK_RESULT $? 0 0 "option: -f last error"
    mtx -f ${PATH_MEDIUMX} previous | grep "done"
    CHECK_RESULT $? 0 0 "option: -f previous error"
    mtx -f ${PATH_MEDIUMX} next | grep "done"
    CHECK_RESULT $? 0 0 "option: -f next error"
    mtx -f ${PATH_MEDIUMX} unload 40 0 | grep "done"
    CHECK_RESULT $? 0 0 "option: -f unload 40 0 error"
    mtx -f ${PATH_MEDIUMX} load 1 0 | grep "done"
    CHECK_RESULT $? 0 0 "option: -f load 1 0 error"
    mtx -f ${PATH_MEDIUMX} transfer 40 41
    CHECK_RESULT $? 0 0 "option: -f transfer 40 41 error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    # Introduce common function
    common_post
    LOG_INFO "End to restore the test environment."
}

main "$@"
