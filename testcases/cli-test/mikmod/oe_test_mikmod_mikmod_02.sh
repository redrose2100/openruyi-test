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
    echo "Q" | mikmod -y common > /dev/null && cat ~/.mikmod_playlist | grep -q "common"
    CHECK_RESULT $? 0 0 "Check mikmod -y failed"
    rm -rf ~/.mikmod_playlist
    echo "Q" | mikmod -directory common > /dev/null && cat ~/.mikmod_playlist | grep -q "common"
    CHECK_RESULT $? 0 0 "Check mikmod -di[rectory] failed"
    mikmod -q & ps | grep -q "mikmod" && kill -INT $!
    CHECK_RESULT $? 0 0 "Check mikmod -q[uiet] failed"
	mikmod -quiet & ps | grep -q "mikmod" && kill -INT $!
    CHECK_RESULT $? 0 0 "Check mikmod -quiet failed"
    echo "Q" | mikmod -v 1 > /dev/null && cat ~/.mikmodrc | grep -q "VOLUME = 1"
    CHECK_RESULT $? 0 0 "Check mikmod -v 1 failed"
	echo "Q" | mikmod -volume 1 > /dev/null && cat ~/.mikmodrc | grep -q "VOLUME = 1"
    CHECK_RESULT $? 0 0 "Check mikmod -volume 1 failed"
	echo "Q" | mikmod -o 8m > /dev/null && cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = no"
    CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 8m failed"
	echo "Q" | mikmod -o 8s > /dev/null && cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 8s failed"
	echo "Q" | mikmod -o 16m > /dev/null && cat ~/.mikmodrc | grep -qE "16BIT = yes|STEREO = no"
    CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 16m failed"
	echo "Q" | mikmod -o 16s > /dev/null && cat ~/.mikmodrc | grep -qE "16BIT = yes|STEREO = yes"
    CHECK_RESULT $? 0 0 "Check mikmod -o[utput] 16s failed"
	echo "Q" | mikmod -output 8m > /dev/null && cat ~/.mikmodrc | grep -qE "16BIT = no|STEREO = no"
    CHECK_RESULT $? 0 0 "Check mikmod -output 8m failed"
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