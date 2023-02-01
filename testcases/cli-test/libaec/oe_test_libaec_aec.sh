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
# @Author    :   ChenZhenpeng LiangZekun
# @Contact   :   1968293081@qq.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST aec
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libaec"
    test -d tmp || mkdir tmp
    LOG_INFO "End to prepare the test environment."
}
# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    aec 2>&1 | grep "OPTIONS"
    CHECK_RESULT $? 0 0 "aec help error"
    aec -n 01 -j 16 -r 16 common/test_p256n01.dat tmp/test_p256n01-basic.rz
    test -f ./tmp/test_p256n01-basic.rz
    CHECK_RESULT $? 0 0 "options: -n 01 -j 16 -r 16 error"
    aec -n 01 -j 16 -r 16 -t common/test_p256n01.dat tmp/test_p256n01-restricted.rz
    test -f ./tmp/test_p256n01-restricted.rz
    CHECK_RESULT $? 0 0 "options: -n 01 -j 16 -r 16 -t error"
    aec -d -n 32 -j 16 -r 256 -p common/sar32bit.j16.r256.rz tmp/sar32bit.dat
    test -f ./tmp/sar32bit.dat
    CHECK_RESULT $? 0 0 "options: -d -n 32 -j 16 -r 256 -p error"
    aec -N common/Lowset1_8bit.dat tmp/Lowset1_8bit--N.rz
    test -f ./tmp/Lowset1_8bit--N.rz
    CHECK_RESULT $? 0 0 "options: -N error"
    aec -s common/Lowset1_8bit.dat tmp/Lowset1_8bit--s.rz
    test -f ./tmp/Lowset1_8bit--s.rz
    CHECK_RESULT $? 0 0 "options: -s error"
    aec -3 common/Lowset1_8bit.dat tmp/Lowset1_8bit--3.rz
    test -f ./tmp/Lowset1_8bit--3.rz
    CHECK_RESULT $? 0 0 "options: -3 error"
    aec -m common/Lowset1_8bit.dat tmp/Lowset1_8bit--m.rz
    test -f ./tmp/Lowset1_8bit--m.rz
    CHECK_RESULT $? 0 0 "options: -m error"
    aec -b 02 common/Lowset1_8bit.dat tmp/Lowset1_8bit--b-02.rz
    test -f ./tmp/Lowset1_8bit--b-02.rz
    CHECK_RESULT $? 0 0 "options: -b 02 error"
    LOG_INFO "End to run test."
}
# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"