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
    DNF_INSTALL "diffutils"
    DNF_INSTALL "texi2html"
    mkdir result
    touch result/warn.texi
    cat <<EOF >result/default.css
#banner {
    background-color: white;
    position: relative;
    text-align: center;
}
EOF
    cat <<EOF >result/error.texi
@chapter Error
@math {(a + b)(a + b) = a^2 + 2ab + b^2}
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -iftex -o=result/iftex.html common/test && grep "iftex_example" result/iftex.html
    CHECK_RESULT $? 0 0 "L$LINENO: -iftex No Pass"

    texi2html -ifxml -o=result/ifxml.html common/test && grep "ifxml_example" result/ifxml.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifxml No Pass"

    texi2html -force -o=result/force.html result/error && find . -name "force.html" | grep force.html
    CHECK_RESULT $? 0 0 "L$LINENO: -force No Pass"

    texi2html -headers -o=result/headers.html common/test && find . -name "headers.html" | grep headers.html
    CHECK_RESULT $? 0 0 "L$LINENO: -headers No Pass"

    texi2html -css-include=result/default.css -o=result/cssinclude.html common/test && grep "banner" result/cssinclude.html
    CHECK_RESULT $? 0 0 "L$LINENO: -css-include No Pass"

    texi2html -disable-encoding -o=result/dsencoding.html common/test && grep -E "this is &eacute; example" result/dsencoding.html
    CHECK_RESULT $? 0 0 "L$LINENO: -disable-encoding No Pass"

    texi2html -enable-encoding -o=result/encoding.html common/test && grep -E "this is é example" result/encoding.html
    CHECK_RESULT $? 0 0 "L$LINENO: -enable-encoding No Pass"

    texi2html -no-warn -o=result/ result/warn 2>result/nowarn.txt && texi2html -o=result/ result/warn 2>result/warn.txt && diff result/warn.txt result/nowarn.txt | grep "warning"
    CHECK_RESULT $? 0 0 "L$LINENO: -no-warn No Pass"

    texi2html -o=result/changeOp.html common/test && find . -name "changeOp.html" | grep "changeOp.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -output|out|o=s No Pass"

    texi2html -prefix=prefixC -o=result/ common/test && find . -name "prefixC.html" | grep "prefixC.html"
    CHECK_RESULT $? 0 0 "L$LINENO: -prefix=s No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
