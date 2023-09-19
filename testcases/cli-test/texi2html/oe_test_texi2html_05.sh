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
    touch lang.texi
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html_05."

    ### --l2h ###
    texi2html -l2h -verbose test 2>l2h.log && grep "l2h: finished from html (no error)" l2h.log
    CHECK_RESULT $? 0 0 "L$LINENO: --l2h No Pass"
    rm -f test.html l2h.log
    ### --internal-links ###
    texi2html -internal-links=links.txt test && find . -name "links.txt" | grep "links.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: -internal-links No Pass"
    rm -f test.html links.txt
    ### --footnote-style ###
    texi2html -footnote-style=end test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    rm -f test.html
    ### --footnote-style ###
    texi2html -footnote-style=separate test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    rm -f test.html
    ### --fill-column ###
    texi2html -fill-column=72 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -fill-column No Pass"
    rm -f test.html 
    ### --error-limit ###
    texi2html -error-limit=1 error 2> error.log || grep "放弃" error.log
    CHECK_RESULT $? 0 0 "L$LINENO: -error-limit No Pass"
    rm -f error.html error.log
    ### --debug=-1 ###
    texi2html -debug=-1 test && find . -name "test.passtexi" | grep "test.passtexi"
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=-1 No Pass"
    rm -f test.passtexi test.html test.passfirst 
    ### --debug=0 ###
    texi2html -debug=0 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=0 No Pass"
    rm -f test.html
    ### --debug=1 ###
    texi2html -debug=1 test 2>debug.log && grep "simple_format" debug.log
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=1 No Pass"
    rm -f test.html debug.log
    ### -document-language=s ###
    texi2html -document-language=zh lang && find . -name "lang.html" | grep "zh" lang.html
    CHECK_RESULT $? 0 0 "L$LINENO: -document-language=s No Pass"
    rm -f lang.texi lang.html
    

    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
