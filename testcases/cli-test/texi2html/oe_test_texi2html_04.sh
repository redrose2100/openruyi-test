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
    LOG_INFO "Start to run testcase:oe_test_texi2html_04."


    ### -css-ref ###
    texi2html -css-ref=default.css test && grep "default.css" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -css-ref No Pass"
    rm -f test.html
    ### -conf-dir ###
    texi2html -conf-dir=conf test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -conf-dir No Pass"
    rm -f test.html
    ### --split=s ###
    texi2html -split=section test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=section No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=chapter test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=chapter No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=node test && find . -name "test" | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=node No Pass"
    rm -rf test
    ### --split=s ###
    texi2html -split=s test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=s No Pass"
    rm -f test.html
    ### --init-file=s ###
    texi2html -init-file=newtexi2html test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -init-file=s No Pass"
    rm -f test.html
    ### --I=s ###
    texi2html -I=include includeTest && grep "authorship" includeTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -I=s No Pass"
    rm -f includeTest.html
    ### --P=s ###
    texi2html -P=include preinclude/includeTest && grep "authorship" includeTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -P=s No Pass"
    rm -f includeTest.html

    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
