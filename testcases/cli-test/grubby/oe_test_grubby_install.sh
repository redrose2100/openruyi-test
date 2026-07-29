#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-20
# @License   :   Mulan PSL v2
# @Desc      :   grubby install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL grubby
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Verify grubby package is installed
    rpm -qa | grep -w grubby
    CHECK_RESULT $? 0 0 "grubby package not installed"
    
    # Step 2: Verify grubby package info
    rpm -qi grubby > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to get grubby package info"
    
    # Step 3: Verify grubby binary location
    ls /usr/sbin/grubby
    CHECK_RESULT $? 0 0 "grubby binary not found"
    
    # Step 4: Verify grubby version works
    grubby --version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby version check failed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"