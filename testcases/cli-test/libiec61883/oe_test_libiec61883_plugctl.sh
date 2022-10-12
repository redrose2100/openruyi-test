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
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST plugctl
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "libiec61883"
    # Simulate equipment or prepare equipment environment
    ln /dev/null /dev/raw1394

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    plugctl -h | grep -q "plugctl:"
    CHECK_RESULT $? 0 0 "option: -h error"

    plugctl oMPR.data_rate
    CHECK_RESULT $? 0 0 "plugctl read error"
    plugctl oMPR.data_rate="test"
    CHECK_RESULT $? 0 0 "plugctl write error"
    plugctl -p 1 oMPR.data_rate
    CHECK_RESULT $? 0 0 "option: -p error"
    plugctl -n 1 oMPR.data_rate
    CHECK_RESULT $? 0 0 "option: -n error"

    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf /dev/raw1394
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"