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

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    modprobe snd-dummy
    DNF_INSTALL "mikmod"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    echo "Q" | mikmod -ren > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check mikmod -ren failed"
    echo "Q" | mikmod -renice > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check mikmod -renice failed"
    echo "Q" | mikmod -norenice > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check mikmod -norenice failed"
    echo "Q" | mikmod -s > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_PRI"
    CHECK_RESULT $? 0 0 "Check mikmod -s failed"
    echo "Q" | mikmod -rea > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check mikmod -rea failed"
    echo "Q" | mikmod -norea > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check mikmod -norea failed"
    echo "Q" | mikmod -realtime > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check mikmod -realtime failed"
    echo "Q" | mikmod -norealtime > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_NONE"
    CHECK_RESULT $? 0 0 "Check mikmod -norealtime failed"
    echo "Q" | mikmod -S > /dev/null && cat ~/.mikmodrc | grep -q "RENICE = RENICE_REAL"
    CHECK_RESULT $? 0 0 "Check mikmod -S failed"
    echo "Q" | mikmod -i > /dev/null && cat ~/.mikmodrc | grep -q "INTERPOLATE = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -i failed"
    echo "Q" | mikmod -noi > /dev/null && cat ~/.mikmodrc | grep -q "INTERPOLATE = no"
    CHECK_RESULT $? 0 0 "Check mikmod -noi failed"
    echo "Q" | mikmod -interpolate > /dev/null && cat ~/.mikmodrc | grep -q "INTERPOLATE = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -interpolate failed"
    echo "Q" | mikmod -nointerpolate > /dev/null && cat ~/.mikmodrc | grep -q "INTERPOLATE = no"
    CHECK_RESULT $? 0 0 "Check mikmod -nointerpolate failed"
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