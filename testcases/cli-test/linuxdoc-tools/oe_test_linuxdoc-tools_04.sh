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
#@Author    :   huxintao
#@Contact   :   806908118@qq.com
#@Date      :   2023/9/03
#@License   :   Mulan PSL v2
#@Desc      :   Test "linuxdoc-tools" command
###################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "linuxdoc-tools"
    cat<<EOF >test.sgml
<!doctype linuxdoc system>
<article>
<title>Quick	Example for Linuxdoc DTD SGML source</title>
<author>
 <name>Hu Xintao</name>
</author>

<abstract>
This document is a brief example using the Linuxdoc DTD SGML.
</abstract>

</article>
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_04."
    linuxdoc -B html test.sgml --tabsize=20 && find . -name "test.html" && grep "Quick      Example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --tabsize No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -t 20 && find . -name "test.html" && grep "Quick      Example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -t No Pass"
    rm -f test.html
    sgml2html test.sgml --tabsize=20 && find . -name "test.html" && grep "Quick      Example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --tabsize No Pass"
    rm -f test.html
    sgml2html test.sgml -t 20 && find . -name "test.html" && grep "Quick      Example" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -t No Pass"
    rm -f test.html
    linuxdoc -B latex test.sgml --tabsize=20 && find . -name "test.tex" && grep "Quick        Example" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --tabsize No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -t 20 && find . -name "test.tex" && grep "Quick        Example" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -t No Pass"
    rm -f test.tex
    sgml2latex test.sgml --tabsize=20 && find . -name "test.tex" && grep "Quick        Example" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --tabsize No Pass"
    rm -f test.tex
    sgml2latex test.sgml -t 20 && find . -name "test.tex" && grep "Quick        Example" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -t No Pass"
    rm -f test.tex
    linuxdoc -B rtf test.sgml --tabsize=20 && find . -name "test.rtf" && grep "Quick      Example" test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --tabsize No Pass"
    rm -f test.rtf
    linuxdoc -B rtf test.sgml -t 20 && find . -name "test.rtf" && grep "Quick      Example" test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -t No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml --tabsize=20 && find . -name "test.rtf" && grep "Quick      Example" test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --tabsize No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml -t 20 && find . -name "test.rtf" && grep "Quick      Example" test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -t No Pass"
    rm -f test.rtf
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_04."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
