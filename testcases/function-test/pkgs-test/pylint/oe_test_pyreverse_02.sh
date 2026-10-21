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
    pyreverse --show-associated 1 string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --show-associated No Pass"
    rm -rf classes.dot
    pyreverse -s 1 string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
    rm -rf classes.dot
    pyreverse --all-associated string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --all-associated No Pass"
    rm -rf classes.dot
    pyreverse -S string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -S No Pass"
    rm -rf classes.dot
    pyreverse --show-builtin string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --show-builtin No Pass"
    rm -rf classes.dot
    pyreverse -b string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -b No Pass"
    rm -rf classes.dot
    pyreverse --module-names y string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --module-names No Pass"
    rm -rf classes.dot    
    pyreverse -m y string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -m No Pass"
    rm -rf classes.dot   
    pyreverse --only-classnames string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --only-classnames No Pass"
    rm -rf classes.dot   
    pyreverse -k string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -k No Pass"
    rm -rf classes.dot   
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"