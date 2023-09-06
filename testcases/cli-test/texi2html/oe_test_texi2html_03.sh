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
    touch tfn.texi rawtext.texi
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html_03."

    ### -transliterate-file-names ###
    texi2html -transliterate-file-names tfn.texi && find . -name "tfn.html" | grep "tfn.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -transliterate-file-names No Pass"
    ### -verbose|v! ###
    texi2html -verbose test 2>verbose.txt && grep "that's all folks" verbose.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -verbose No Pass"
    ### -raw-text ###
    texi2html -raw-text rawtext && find . -name "rawtext.txt" | grep "rawtext.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: -raw-text No Pass"
    ### -toc-links ###
    texi2html -toc-links test && grep "test.html#toc-Contributing-code" "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -toc-links No Pass"
    rm -f test.html
    ### -use-nodes ###
    texi2html -use-nodes test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -use-nodes No Pass"
    rm -f test.html
    ### -top-file ###
    texi2html -top-file=topfileTest test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -top-file No Pass"
    rm -f test.html
    ### -toc-file ###
    texi2html -toc-file=test test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -toc-file No Pass"
    rm -f test.html
    ### -split-size ###
    texi2html -split-size=30000 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -split-size No Pass"
    rm -f test.html
    ### -short-ext ###
    texi2html -short-ext test.texi && find . -name "test.htm" | grep "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: -short-ext No Pass"
    ### -short-ref ###
    texi2html -short-ref test.texi && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -short-ref No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.htm tfn.html verbose.txt rawtext.txt
    rm -f tfn.texi rawtext.texi test.html
    LOG_INFO "End to restore the test environment."
}

main "$@"
