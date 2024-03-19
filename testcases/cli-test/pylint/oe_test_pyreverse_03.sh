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
    pyreverse --output dot string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --output No Pass"
    rm -rf classes.dot
    pyreverse -o dot string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -o No Pass"
    rm -rf classes.dot 
    pyreverse --ignore CVS string
    find . -name "classes.dot" | grep "classes.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --ignore No Pass"
    rm -rf classes.dot
    pyreverse --project none string
    find . -name "classes_none.dot" | grep "classes_none.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: --project No Pass"
    rm -rf classes_none.dot
    pyreverse -p none string
    find . -name "classes_none.dot" | grep "classes_none.dot"
    CHECK_RESULT $? 0 0 "L$LINENO: -p No Pass"
    rm -rf classes_none.dot
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"