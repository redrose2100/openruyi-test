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

source "${OET_PATH}/libs/locallibs/common_lib.sh"

#Installation preparation for test objects, tools required for testing, etc.
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    modprobe snd-dummy
    ret=$?
    if [ $ret -ne 0 ] ;then
        LOG_WARN "The current kernel does not have the snd-dummy module."
        exit 255
    fi
    DNF_INSTALL "mikmod"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    echo "Q" | mikmod -f 11025 > /dev/null && grep "FREQUENCY = 11025" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -f 11025 failed"
    echo "Q" | mikmod -frequency 11025 > /dev/null && grep "FREQUENCY = 11025" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -frequency 11025 failed"
    echo "Q" | mikmod -r 0 > /dev/null && grep "REVERB = 0" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -r 0 failed"
    echo "Q" | mikmod -reverb 0 > /dev/null && grep "REVERB = 0" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -reverb 0 failed"
    echo "Q" | mikmod -F > /dev/null && grep "FADEOUT = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -F failed"
    echo "Q" | mikmod -nofa > /dev/null && grep "FADEOUT = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nofa failed"
    echo "Q" | mikmod -fa > /dev/null && grep "FADEOUT = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -fa failed"
    echo "Q" | mikmod -fadeout > /dev/null && grep "FADEOUT = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -fadeout failed"
    echo "Q" | mikmod -nofadeout > /dev/null && grep "FADEOUT = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nofadeout failed"
    echo "Q" | mikmod -l > /dev/null && grep "LOOP = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -l failed"
    echo "Q" | mikmod -nol > /dev/null && grep "LOOP = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -nol failed"
    echo "Q" | mikmod -loops > /dev/null && grep "LOOP = yes" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -loops failed"
    echo "Q" | mikmod -noloops > /dev/null && grep "LOOP = no" ~/.mikmodrc
    CHECK_RESULT $? 0 0 "Check mikmod -noloops failed"
    LOG_INFO "End to run test."
}

# Post-processing, restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    modprobe -r snd-dummy
    rm -rf ~/.mikmod*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"