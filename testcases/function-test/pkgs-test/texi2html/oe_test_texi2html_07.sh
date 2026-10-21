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
    cat << EOF > result/error.texi
@chapter Error
@math {(a + b)(a + b) = a^2 + 2ab + b^2}
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    texi2html -v -o=result/verbose.html common/test 2>result/verbose.txt && grep "that's all folks" result/verbose.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -v No Pass"
    
    texi2html -F -o=result/force.html result/error && find . -name "force.html" | grep force.html
    CHECK_RESULT $? 0 0 "L$LINENO: -F No Pass"
   
    texi2html -output=result/changeOutput.html common/test && find . -name "changeOutput.html" | grep "changeOutput.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output=s No Pass"
   
    texi2html -o=result/changeOut.html common/test && find . -name "changeOutput.html" | grep "changeOutput.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -out=s No Pass"
    
    texi2html -help | grep -E "Usage: texi2html"
    CHECK_RESULT $? 0 0 "L$LINENO: -help No Pass"
  
    texi2html -s=end -o=result/ftsE.html common/test && find . -name "ftsE.html" | grep "ftsE.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  
    texi2html -s=separate -o=result/ftsS.html common/test && find . -name "ftsS.html" | grep "ftsS.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -s No Pass"
  
    texi2html -e=1 -o=result/error.html result/error 2> result/error.log || grep "result/error.texi:2: @math" result/error.log
    CHECK_RESULT $? 0 0 "L$LINENO: -e No Pass"
    
    texi2html -no-pointer-validate -o=result/no-validate.html common/test && find . -name "no-validate.html" | grep "no-validate.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-pointer-validate No Pass"
    
    texi2html -E=result/macroE.txt -o=result/macro.html common/test &&  grep "input texinfo" result/macroE.txt
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
