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
    echo "Q" | mikmod -pa > /dev/null && grep "PANNING = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -pa failed"
    echo "Q" | mikmod -nopa > /dev/null && grep "PANNING = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nopa failed"
    echo "Q" | mikmod -a > /dev/null && grep "PANNING = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -a failed"
    echo "Q" | mikmod -panning > /dev/null && grep "PANNING = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -panning failed"
    echo "Q" | mikmod -nopanning > /dev/null && grep "PANNING = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nopanning failed"
    echo "Q" | mikmod -pr > /dev/null && grep "EXTSPD = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -pr failed"
    echo "Q" | mikmod -nopr > /dev/null && grep "EXTSPD = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nopr failed"
    echo "Q" | mikmod -x > /dev/null && grep "EXTSPD = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -x failed"
    echo "Q" | mikmod -protracker > /dev/null && grep "EXTSPD = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -protracker failed"
    echo "Q" | mikmod -noprotracker > /dev/null && grep "EXTSPD = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -noprotracker failed"
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