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
    mkdir /usr/local/share/perl5 result preinclude include
    cp -r common /usr/local/share/perl5
    cat << EOF > includeTest.texi
@include authors.texi
EOF
    cat << EOF > include/authors.texi
@chapter Authors
@math{(a + b)(a + b) = a^2 + 2ab + b^2}
EOF
    cp includeTest.texi preinclude/
    touch default.css
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -css-ref=default.css -o=result/css-ref.html common/test && grep "default.css" result/css-ref.html
    CHECK_RESULT $? 0 0 "L$LINENO: -css-ref No Pass"
       
    texi2html -conf-dir=common -init-file=texi2html.init -o=result/conf.html common/test 2>result/conf.txt && grep "processed" result/conf.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -conf-dir No Pass"
    
    texi2html -split=section -o=result/splictsection common/test && grep "Up" result/splictsection/test_22.html
    CHECK_RESULT $? 0 0 "L$LINENO: -split=section No Pass"
    
    texi2html -split=chapter -o=result/splictC common/test && grep "Release process" result/splictC/test_8.html
    CHECK_RESULT $? 0 0 "L$LINENO: -split=chapter No Pass"
    
    texi2html -split=node -o=result/splictN common/test && grep "Release Checklist" result/splictN/test_22.html
    CHECK_RESULT $? 0 0 "L$LINENO: -split=node No Pass"
    
    texi2html -split=s -o=result/splictS.html common/test && find . -name "splictS.html" | grep "splictS.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -split=s No Pass"
    
    texi2html -init-file=common/texi2html.init -o=result/initf.html common/test 2>result/initf.txt && grep "processed" result/initf.txt
    CHECK_RESULT $? 0 0 "L$LINENO: -init-file=s No Pass"
    
    texi2html -I=include -o=result/ includeTest && grep "Authors" result/includeTest.html
    CHECK_RESULT $? 0 0 "L$LINENO: -I=s No Pass"
    
    texi2html -P=include -o=result/includeTestP.html preinclude/includeTest && grep "Authors" result/includeTestP.html
    CHECK_RESULT $? 0 0 "L$LINENO: -P=s No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result include preinclude /usr/local/share/perl5 includeTest.texi default.css
    LOG_INFO "End to restore the test environment."
}

main "$@"
