#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   guheping
#@Contact   :   867559702@qq.com
#@Date      :   2022/9/15
#@License   :   Mulan PSL v2
#@Desc      :   Test "pyjunitxml" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "python3-junitxml"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pyjunitxml-3 --h | grep "Usage: pyjunitxml-3"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    pyjunitxml-3 --help | grep "Usage: pyjunitxml-3"
    CHECK_RESULT $? 0 0 "L$LINENO: --help No Pass"
    pyjunitxml-3 -o ./junit.xml 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
    pyjunitxml-3 --output-file=./junit.xml 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --output-file No Pass"
    pyjunitxml-3 -s . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    pyjunitxml-3 --start-directory . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --start-directory No Pass"
    pyjunitxml-3 -t . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -t No Pass"
    pyjunitxml-3 --top-level-directory . 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --top-level-directory No Pass"
    pyjunitxml-3 -p test*.py 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    pyjunitxml-3 --pattern test*.py 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "L$LINENO: --pattern No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf junit.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
