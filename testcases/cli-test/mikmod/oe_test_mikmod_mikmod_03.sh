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
    echo "Q" | mikmod -c > /dev/null && cat ~/.mikmodrc | grep -q "CURIOUS = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -c failed"
    echo "Q" | mikmod -noc > /dev/null && cat ~/.mikmodrc | grep -q "CURIOUS = no"
    CHECK_RESULT $? 0 0 "Check mikmod -noc failed"
    echo "Q" | mikmod -curious > /dev/null && cat ~/.mikmodrc | grep -q "CURIOUS = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -curious failed"
    echo "Q" | mikmod -nocurious > /dev/null && cat ~/.mikmodrc | grep -q "CURIOUS = no"
    CHECK_RESULT $? 0 0 "Check mikmod -nocurious failed"
    echo "Q" | mikmod -p 1 > /dev/null && cat ~/.mikmodrc | grep -q "PM_MODULE = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -p 1 failed"
    echo "Q" | mikmod -p 2 > /dev/null && cat ~/.mikmodrc | grep -q "PM_MULTI = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -p 2 failed"
    echo "Q" | mikmod -p 4 > /dev/null && cat ~/.mikmodrc | grep -q "PM_SHUFFLE = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -p 4 failed"
    echo "Q" | mikmod -p 8 > /dev/null && cat ~/.mikmodrc | grep -q "PM_RANDOM = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -p 8 failed"
    echo "Q" | mikmod -playmode 1 > /dev/null && cat ~/.mikmodrc | grep -q "PM_MODULE = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -playmode 1 failed"
    echo "Q" | mikmod -t > /dev/null && cat ~/.mikmodrc | grep -q "TOLERANT = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -t failed"
    echo "Q" | mikmod -not > /dev/null && cat ~/.mikmodrc | grep -q "TOLERANT = no"
    CHECK_RESULT $? 0 0 "Check mikmod -not failed"
    echo "Q" | mikmod -tolerant > /dev/null && cat ~/.mikmodrc | grep -q "TOLERANT = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -tolerant failed"
    echo "Q" | mikmod -notolerant > /dev/null && cat ~/.mikmodrc | grep -q "TOLERANT = no"
    CHECK_RESULT $? 0 0 "Check mikmod -notolerant failed"
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