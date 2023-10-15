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
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -program=s -o=result/program.txt common/test && grep "TestExample Documentation" result/program.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -program No Pass"

    texi2html -paragraph-indent=1000 -o=result/pinum.html common/test && find . -name "pinum.html" | grep "pinum.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    
    texi2html -paragraph-indent=none -o=result/pin.html common/test && find . -name "pin.html" | grep "pin.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    
    texi2html -paragraph-indent=asis -o=result/pia.html common/test && find . -name "pia.html" | grep "pia.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -paragraph-indent No Pass"
    
    texi2html -output-indent=1000 -o=result/optinum.html common/test && find . -name "optinum.html" | grep "optinum.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output-indent No Pass"
    
    texi2html -number-sections -o=result/numsec.html common/test && find . -name "numsec.html" | grep "numsec.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
    
    texi2html -number-footnotes -o=result/numftn.html common/test && find . -name "numftn.html" | grep "numftn.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-footnotes No Pass"
    
    texi2html -node-files -o=result/node_files/ common/test && find . -name "Coding-Rules.html" | grep "Coding-Rules.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -number-sections No Pass"
    
    texi2html -no-validate -o=result/no-validate.html common/test && find . -name "no-validate.html" | grep "no-validate.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-validate|no-pointer-validate No Pass"
    
    texi2html -macro-expand=result/macroE.txt -o=result/macro.html common/test &&  grep "input texinfo" result/macroE.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -macro-expand No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
