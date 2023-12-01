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
    touch lang.texi
    mkdir result
    cat << EOF > result/error.texi
@chapter Error
@math {(a + b)(a + b) = a^2 + 2ab + b^2}
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -l2h -o=result/l2h.html -verbose common/test 2> result/l2h.log && grep "l2h: finished from html (no error)" result/l2h.log
    CHECK_RESULT $? 0 0 "L$LINENO: --l2h No Pass"
    
    texi2html -internal-links=result/links.txt -o=result/link.html common/test && grep "Introduction" result/links.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -internal-links No Pass"
    
    texi2html -footnote-style=end -o=result/ftsE.html common/test && find . -name "ftsE.html" | grep "ftsE.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    
    texi2html -footnote-style=separate -o=result/ftsS.html common/test && find . -name "ftsS.html" | grep "ftsS.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -footnote-style No Pass"
    
    texi2html -fill-column=72 -o=result/fillcolumn.html common/test && find . -name "fillcolumn.html" | grep "fillcolumn.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -fill-column No Pass"l 
    
    texi2html -error-limit=1 -o=result/error.html result/error 2> result/error.log || grep "result/error.texi:2: @math" result/error.log
    CHECK_RESULT $? 0 0 "L$LINENO: -error-limit No Pass"
    
    texi2html -debug=-1 common/test && find . -name "test.passtexi" | grep "test.passtexi"
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=-1 No Pass"
    rm -rf test.passtexi test.html test.passfirst 
    
    texi2html -debug=0 common/test && find . -name "test.html" | grep "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=0 No Pass"
    rm -rf test.html
    
    texi2html -debug=1 common/test 2>result/debug.log && grep "simple_format" result/debug.log
    CHECK_RESULT $? 0 0 "L$LINENO: -debug=1 No Pass"
    rm -rf test.html
    
    texi2html -document-language=zh lang && grep "zh" lang.html
    CHECK_RESULT $? 0 0 "L$LINENO: -document-language=s No Pass"
    rm -rf lang.texi lang.html
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
