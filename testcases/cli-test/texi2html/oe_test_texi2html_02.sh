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
#@Date      :   2023/9/18
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    touch forceTest.texi headersTest.texi codingTest.texi warnTest.texi
    touch output.texi prefix.texi
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html_02."

    ### -iftex ###
    texi2html -iftex test && grep "iftex_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -iftex No Pass"
    rm -f test.html
    ### -ifxml ###
    texi2html -ifxml test && grep "ifxml_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifxml No Pass"
    LOG_INFO "End to run test."
    ### -force|F ###
    texi2html -force forceTest.texi && find . -name "forceTest.html" | grep forceTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -force No Pass"
    ### -headers ###
    texi2html -headers headersTest.texi && find . -name "headersTest.html" | grep headersTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -headers No Pass"
    ### -css-include ###
    texi2html -css-include=default.css test && grep "banner" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -css-include No Pass"
    rm -f test.html
    ### -disable-encoding ###
    texi2html -disable-encoding codingTest.texi && find . -name "codingTest.html" | grep "codingTest.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -disable-encoding No Pass"
    ### -enable-encoding ###
    rm -f codingTest.html
    texi2html -enable-encoding codingTest.texi && find . -name "codingTest.html" | grep "codingTest.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -enable-encoding No Pass"
    ### -no-warn ###
    texi2html -no-warn warnTest.texi && find . -name "warnTest.html" | grep "warnTest.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-warn No Pass"
    ### --output|out|o=s ###
    texi2html -o=changeOp.html output.texi && find . -name "changeOp.html" | grep "changeOp.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output|out|o=s No Pass"
    ### --prefix=s ###
    texi2html -prefix=prefixC prefix.texi && find . -name "prefixC.html" | grep "prefixC.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -prefix=s No Pass"
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.html prefix.texi prefixC.html
    rm -f forceTest.texi headersTest.texi codingTest.texi warnTest.texi output.texi
    rm -f forceTest.html cssTest.html headersTest.html codingTest.html warnTest.html changeOp.html
    LOG_INFO "End to restore the test environment."
}

main "$@"
