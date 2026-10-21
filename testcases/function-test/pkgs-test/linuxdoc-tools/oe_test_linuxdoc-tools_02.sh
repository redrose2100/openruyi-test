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
<title>Quick Example for Linuxdoc DTD SGML source</title>
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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_02."
    linuxdoc -B latex test.sgml --papersize=letter && find . -name "test.tex" && grep letterpaper test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --papersize No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -p letter && find . -name "test.tex" && grep letterpaper test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -p No Pass"
    rm -f test.tex
    sgml2latex test.sgml --papersize=letter && find . -name "test.tex" && grep letterpaper test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --papersize No Pass"
    rm -f test.tex
    sgml2latex test.sgml -p letter && find . -name "test.tex" && grep letterpaper test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -p No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml --language=german  && find . -name "test.tex" && grep german test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --language No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -l german && find . -name "test.tex" && grep german test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -l No Pass"
    rm -f test.tex
    sgml2latex test.sgml --language=german && find . -name "test.tex" && grep german test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --language No Pass"
    rm -f test.tex
    sgml2latex test.sgml -l german && find . -name "test.tex" && grep german test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -l No Pass"
    rm -f test.tex
    linuxdoc -B lyx test.sgml --language=german && find . -name "test.lyx" && grep german test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx --language No Pass"
    rm -f test.lyx
    linuxdoc -B lyx test.sgml -l german && find . -name "test.lyx" && grep german test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx -l No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml --language=german && find . -name "test.lyx" && grep german test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx --language No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml -l german && find . -name "test.lyx" && grep german test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx -l No Pass"
    rm -f test.lyx
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_02."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
