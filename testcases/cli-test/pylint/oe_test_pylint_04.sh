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
#@Date      :   2022/12/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "pylint" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "pylint"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    pylint -d C0103 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -d <msg ids> No Pass"
    pylint --disable=C0103 ./common/test.py | grep "Module test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --disable=<msg ids> No Pass"
    pylint -f json ./common/test.py | grep "type"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -f <format> No Pass"
    pylint --output-format=json ./common/test.py | grep "type"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -f <format> No Pass"
    pylint -r y ./common/test.py | grep "Report"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -r <y_or_n> No Pass"
    pylint --reports=y ./common/test.py | grep "Report"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -r <y_or_n> No Pass"
    pylint --evaluation 9 ./common/test.py | grep "9.00"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --evaluation <python_expression> No Pass"
    pylint -s y ./common/test.py | grep "Your code has been rated at"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint -s <y_or_n> No Pass"
    pylint --score=y y ./common/test.py | grep "Your code has been rated at"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --score <y_or_n> No Pass"
    pylint --msg-template=test ./common/test.py | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: pylint --msg-template <template> No Pass"
    pylint --version | grep "pylint"
    CHECK_RESULT $? 0 0 "L$LINENO: --version No Pass"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"