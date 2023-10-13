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
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    mkdir result
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -transliterate-file-names -o=result/tfn.html common/test && find . -name "tfn.html" | grep "tfn.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -transliterate-file-names No Pass"
    
    texi2html -verbose -o=result/verbose.html common/test 2>result/verbose.txt && grep "that's all folks" result/verbose.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -verbose No Pass"
    
    texi2html -raw-text -o=result/rawtext.txt common/test && grep "TestExample" result/rawtext.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -raw-text No Pass"
    
    texi2html -toc-links -o=result/toclink.html common/test && grep "toclink.html#toc-Contributing-code" result/toclink.html
    CHECK_RESULT $? 0 0 "L$LINENO: -toc-links No Pass"
    
    texi2html -use-nodes -o=result/usenodes.html common/test && find . -name "usenodes.html" | grep "usenodes.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -use-nodes No Pass"
    
    texi2html -top-file=topfileTest -o=result/topfile.html common/test && find . -name "topfile.html" | grep "topfile.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -top-file No Pass"
    
    texi2html -toc-file=test -o=result/tocfile.html common/test && find . -name "tocfile.html" | grep "tocfile.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -toc-file No Pass"
    
    texi2html -split-size=30000 -o=result/splite-size.html common/test && find . -name "splite-size.html" | grep "splite-size.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -split-size No Pass"
    
    texi2html -short-ext -o=result/ common/test && find . -name "test.htm" | grep "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: -short-ext No Pass"
    
    texi2html -short-ref -o=result/sref.html common/test && find . -name "sref.html" | grep "sref.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -short-ref No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
