#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2022/8/26
#@License   :   Mulan PSL v2
#@Desc      :   Test "rhino" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "rhino"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_rhino_01."
    echo "print('answer'+42.0);" | rhino -w | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -w No Pass"
    echo "print('answer'+42.0);" | rhino -version 100 | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"
    echo "print('answer'+42.0);" | rhino -opt 1 | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -opt No Pass"
    echo "print('answer'+42.0);" | rhino -modules /usr/share | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -modules No Pass"
    echo "print('answer'+42.0);" | rhino -require | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -require No Pass"
    echo "print('answer'+42.0);" | rhino -sandbox | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -sandbox No Pass"
    echo "print('answer'+42.0);" | rhino -debug | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -debug No Pass"
    echo "print('answer'+42.0);" | rhino -strict | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -strict No Pass"
    echo "print('answer'+42.0);" | rhino -fatal-warnings | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -fatal-warnings No Pass"
    echo "print('answer'+42.0);" | rhino -encoding utf-8 | grep "answer42"
    CHECK_RESULT $? 0 0 "L$LINENO: -encoding charset No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"