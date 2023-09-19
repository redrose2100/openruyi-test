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
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/9/06
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html_06."


    ### -program=s ###
    texi2html -program=s test && find . -name "test.txt" | grep "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: -program=s No Pass"
    rm -f test.txt
    ### -paragraph-indent ###
    texi2html -paragraph-indent=1000 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### -paragraph-indent ###
    texi2html -paragraph-indent=none test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### -paragraph-indent ###
    texi2html -paragraph-indent=asis test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### -output-indent ###
    texi2html -output-indent=1000 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output-indent No Pass"
    rm -f test.html
    ### -number-sections ###
    texi2html -number-sections test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
    rm -f test.html
    ### -number-footnotes ###
    texi2html -number-footnotes test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-footnotes No Pass"
    rm -f test.html
    ### -node-files ###
    texi2html -node-files test && find . -name "Development-Policy.html" | grep "Development-Policy.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
    rm -f test.html Coding-Rules.html Criteria-for-Point-Releases.html Development-Policy.html 
    rm -f Regression-tests.html Release-process.html Submitting-patches.html
    ### -no-validate|no-pointer-validate ###
    texi2html -no-validate test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-validate|no-pointer-validate No Pass"
    rm -f test.html
    ### -macro-expand ###
    texi2html -macro-expand=macro test && find . -name "macro" | grep "macro"
    CHECK_RESULT $? 0 0 "L$LINENO: -macro-expand No Pass"
    rm -f test.html macro


    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
