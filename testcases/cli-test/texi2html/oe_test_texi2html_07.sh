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
    touch forceTest.texi output.texi
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_texi2html_07."
    ### -verbose|v ###
    texi2html -v test 2>verbose.txt && grep "that's all folks" verbose.txt
    LOG_INFO "End to run test."
    ### -F ###
    texi2html -F forceTest.texi && find . -name "forceTest.html" | grep forceTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -force No Pass"
    ### --output=s ###
    texi2html -output=changeOp.html output.texi && find . -name "changeOp.html" | grep "changeOp.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output|out|o=s No Pass"
    rm -f changeOp.html
    ### --out=s ###
    texi2html -out=changeOp.html output.texi && find . -name "changeOp.html" | grep "changeOp.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output|out|o=s No Pass"
     ### -help ###
    texi2html -help | grep -E "Usage: texi2html"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### --s ###
    texi2html -s=end test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    rm -f test.html
    ### --s ###
    texi2html -s=separate test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    rm -f test.html
    ### --e ###
    texi2html --e=1 error 2> error.log || grep "放弃" error.log
    CHECK_RESULT $? 0 0 "L$LINENO: -error-limit No Pass"
    rm -f error.html error.log
     ### -no-pointer-validate ###
    texi2html -no-pointer-validate test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-validate|no-pointer-validate No Pass"
    rm -f test.html
    ### -E ###
    texi2html -E=macro test && find . -name "macro" | grep "macro"
    CHECK_RESULT $? 0 0 "L$LINENO: -macro-expand No Pass"
    rm -f test.html macro
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f forceTest.texi forceTest.html output.texi changeOp.html verbose.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
