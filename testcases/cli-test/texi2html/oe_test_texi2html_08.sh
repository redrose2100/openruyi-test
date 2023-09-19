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
    LOG_INFO "Start to run testcase:oe_test_texi2html_08."

    ### -p ###
    texi2html -p=1000 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### -p ###
    texi2html -p=none test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### -p ###
    texi2html -p=asis test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    rm -f test.html
    ### --f ###
    texi2html -f=72 test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -fill-column No Pass"
    rm -f test.html 
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
