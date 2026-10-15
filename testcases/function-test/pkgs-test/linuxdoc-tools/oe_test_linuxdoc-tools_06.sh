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
    DNF_INSTALL "linuxdoc-tools texinfo"
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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_06."
    linuxdoc -B html test.sgml --debug | grep finished && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --debug No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -d | grep finished && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -d No Pass"
    rm -f test.html
    sgml2html test.sgml --debug | grep finished && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --debug No Pass"
    rm -f test.html
    sgml2html test.sgml -d | grep finished && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -d No Pass"
    rm -f test.html
    linuxdoc -B info test.sgml --debug | grep finished && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --debug No Pass"
    rm -f test.info
    linuxdoc -B info test.sgml -d | grep finished && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -d No Pass"
    rm -f test.info
    sgml2info test.sgml --debug | grep finished && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --debug No Pass"
    rm -f test.info
    sgml2info test.sgml -d | grep finished && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -d No Pass"
    rm -f test.info
    linuxdoc -B latex test.sgml --debug | grep finished && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --debug No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -d | grep finished && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -d No Pass"
    rm -f test.tex
    sgml2latex test.sgml --debug | grep finished && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --debug No Pass"
    rm -f test.tex
    sgml2latex test.sgml -d | grep finished && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -d No Pass"
    rm -f test.tex
    linuxdoc -B lyx test.sgml --debug | grep finished && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx --debug No Pass"
    rm -f test.lyx
    linuxdoc -B lyx test.sgml -d 20 | grep finished && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx -d No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml --debug | grep finished && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx --debug No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml -d | grep finished && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx -d No Pass"
    rm -f test.lyx
    linuxdoc -B rtf test.sgml --debug | grep finished && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --debug No Pass"
    rm -f test.rtf
    linuxdoc -B rtf test.sgml -d 20 | grep finished && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -d No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml --debug | grep finished && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --debug No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml -d | grep finished && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -d No Pass"
    rm -f test.rtf
    linuxdoc -B txt test.sgml --debug | grep finished && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --debug No Pass"
    rm -f test.rtf
    linuxdoc -B txt test.sgml -d 20 | grep finished && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -d No Pass"
    rm -f test.txt
    sgml2txt test.sgml --debug | grep finished && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --debug No Pass"
    rm -f test.txt
    sgml2txt test.sgml -d | grep finished && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -d No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_06."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
