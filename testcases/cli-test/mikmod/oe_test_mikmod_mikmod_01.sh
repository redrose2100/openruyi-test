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
# @Author    :   hanliyi
# @Contact   :   1032864780@qq.com
# @Date      :   2022/09/30
# @License   :   Mulan PSL v2
# @Desc      :   TEST mikmod options
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    modprobe snd-dummy
    DNF_INSTALL "mikmod"
    VERSION=$(rpm -qa mikmod | awk -F '-' '{print $2}')
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    mikmod -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check mikmod-h failed."
    mikmod --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check mikmod--help failed"
    mikmod -V | grep -q "${VERSION}" 
    CHECK_RESULT $? 0 0 "Check mikmod-V failed"
    mikmod -version | grep -q "${VERSION}"
    CHECK_RESULT $? 0 0 "Check mikmod-version failed"
    mikmod -n | grep -q "drivers"
    CHECK_RESULT $? 0 0 "Check mikmod-n failed"
    mikmod -information | grep -q "drivers"
    CHECK_RESULT $? 0 0 "Check mikmod-in[formation] failed"
    mikmod -N 1 | grep "Parameter list"
    CHECK_RESULT $? 0 0 "Check mikmod-N 1 failed"
    mikmod -drvinfo 1 | grep "Parameter list"
    CHECK_RESULT $? 0 0 "Check mikmod-drvinfo 1 failed"
	echo "Q" | mikmod -d 1 > /dev/null && cat ~/.mikmodrc | grep -q "DRIVER = 1"
	CHECK_RESULT $? 0 0 "Check mikmod-d 1 failed"
	echo "Q" | mikmod -driver 2 > /dev/null && cat ~/.mikmodrc | grep -q "DRIVER = 2"
	CHECK_RESULT $? 0 0 "Check mikmod-driver 2 failed"
    LOG_INFO "End to run test."
}

# Post-processing, restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    modprobe -r snd-dummy
    rm -rf ~/.mikmod*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"