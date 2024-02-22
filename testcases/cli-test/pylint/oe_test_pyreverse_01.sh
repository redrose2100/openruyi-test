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
    pyreverse -h | grep -E "pyreverse"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    pyreverse --help | grep -E "pyreverse"
    CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
    pyreverse --filter-mode PUB_ONLY string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --filter-mode No Pass"
    rm -rf classes.dot
    pyreverse -f PUB_ONLY string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -f No Pass"
    rm -rf classes.dot
    pyreverse --class pylint.checkers.classes.ClassChecker pylint
    find . -name "pylint.checkers.classes.ClassChecker.dot" | grep "pylint.checkers.classes.ClassChecker.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -class No Pass"
    rm -rf pylint.checkers.classes.ClassChecker.dot
    pyreverse -c pylint.checkers.classes.ClassChecker pylint
    find . -name "pylint.checkers.classes.ClassChecker.dot" | grep "pylint.checkers.classes.ClassChecker.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -c No Pass"
    rm -rf pylint.checkers.classes.ClassChecker.dot
    pyreverse --show-ancestors 1 string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --show-ancestors No Pass"
    rm -rf classes.dot
    pyreverse -a 1 string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -a No Pass"
    rm -rf classes.dot
    pyreverse --all-ancestors string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --all-ancestors No Pass"
    rm -rf classes.dot
    pyreverse -A string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -A No Pass"
    rm -rf classes.dot 
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"