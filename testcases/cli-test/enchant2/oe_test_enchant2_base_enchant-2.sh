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
# @Author    :   GaoNan ZhouZhenBin WuXiChuan
# @Contact   :   690895849@qq.com
# @Date      :   2022/10/02
# @License   :   Mulan PSL v2
# @Desc      :   TEST enchant-2
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    export LANG=en_US.UTF-8
    test -d tmp || mkdir tmp 
    echo "I miss you.
I nedd you.
Thi is a wrongg stencees." > ${TMP_DIR}/test.in
    echo "& nedd 2 2: need, nerd
& Thi 13 0: Thu, Th, Ti, Hi, Thai, Chi, Phi, T hi, Th i, Thigh, Thee, Tho, This
& wrongg 3 9: wrong, wrongs, wrong g
& stencees 5 16: stenches, existences, sentences, sentence, senescence" > ${TMP_DIR}/test.refs
    LOG_INFO "End to config params of the case."
}

# Preparation for installation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "enchant2"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    enchant-2 -h 2>&1 | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    enchant-2 -v | grep -E "[0-9.]+"
    CHECK_RESULT $? 0 0 "option: -v error"
    enchant-2 -l < $tmp/test.in | grep $'nedd\nThi\nwrongg\nstencees'
    CHECK_RESULT $? 0 0 "option: -l STDIN error"
    enchant-2 -l $tmp/test.in | grep $'nedd\nThi\nwrongg\nstencees'
    CHECK_RESULT $? 0 0 "option: -l FILEIN error"
    enchant-2 -l -d en_AU $tmp/test.in | grep $'nedd\nThi\nwrongg\nstencees'
    CHECK_RESULT $? 0 0 "option: -d error"
    enchant-2 -l -L $tmp/test.in | grep $'2 nedd\n3 Thi\n3 wrongg\n3 stencees'
    CHECK_RESULT $? 0 0 "option: -L error"
    enchant-2 -a $tmp/test.in | grep "^& " | diff -u $tmp/test.refs -
    CHECK_RESULT $? 0 0 "option: -a error"
    LOG_INFO "End to run test."
}

# Post-processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf $tmp 
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
