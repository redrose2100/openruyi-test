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
#@Author    :   Liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/9/18
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
    LOG_INFO "Start to run testcase:oe_test_texi2html_01."
    ### -h ###
    texi2html -h | grep -E "Usage: texi2html"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"
    ### -version ###
    texi2html -version | grep -E "5.0"
    CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"
    ### -docbook ###
    texi2html -docbook test.texi && find . -name "test.xml" | grep test.xml
    CHECK_RESULT $? 0 0 "L$LINENO: -docbook No Pass"
    rm -f test.xml
    ### -menu ###
    texi2html -menu test.texi && find . -name "test.html" | grep test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -menu No Pass"
    rm -f test.html
    ### -info ###
    texi2html -info test.texi && find . -name "test.info" | grep test.info
    CHECK_RESULT $? 0 0 "L$LINENO: -info No Pass"
    ### -xml ###
    texi2html -xml test.texi && find . -name "test.xml" | grep test.xml
    CHECK_RESULT $? 0 0 "L$LINENO: -xml No Pass"
    ### -ifdocbook ###
    texi2html -ifdocbook test && grep "ifdocbook_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifdocbook No Pass"
    rm -f test.html
    ### -ifhtml ###
    texi2html -ifhtml test && grep "ifhtml_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifhtml No Pass"
    rm -f test.html
    ### -ifinfo ###
    texi2html -ifinfo test && grep "ifinfo_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifinfo No Pass"
    rm -f test.html
    ### -ifplaintext ###
    texi2html -ifplaintext test && grep "ifplaintext_example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifplaintext No Pass"
    
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.html test.info test.xml
    LOG_INFO "End to restore the test environment."
}

main "$@"
