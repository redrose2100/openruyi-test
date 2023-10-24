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
This document is a brief example using the Linuxdoc DTD SGML.<#unless version=test1>test2</#unless>
</abstract>

</article>
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_07."
    linuxdoc -B html test.sgml --define=version=test2 && find . -name "test.html" && grep test2 test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --define No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -D version=test2 && find . -name "test.html" && grep test2 test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -D No Pass"
    rm -f test.html
    sgml2html test.sgml --define=version=test2 && find . -name "test.html" && grep test2 test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --define No Pass"
    rm -f test.html
    sgml2html test.sgml -D version=test2 && find . -name "test.html" && grep test2 test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -D No Pass"
    rm -f test.html
    linuxdoc -B info test.sgml --define=version=test2 && find . -name "test.info" && grep test2 test.info
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --define No Pass"
    rm -f test.info
    linuxdoc -B info test.sgml -D version=test2 && find . -name "test.info" && grep test2 test.info
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -D No Pass"
    rm -f test.info
    sgml2info test.sgml --define=version=test2 && find . -name "test.info" && grep test2 test.info
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --define No Pass"
    rm -f test.info
    sgml2info test.sgml -D version=test2 && find . -name "test.info" && grep test2 test.info
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -D No Pass"
    rm -f test.info
    linuxdoc -B latex test.sgml --define=version=test2 && find . -name "test.tex" && grep test2 test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --define No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -D version=test2 && find . -name "test.tex" && grep test2 test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B tex -D No Pass"
    rm -f test.tex
    sgml2latex test.sgml --define=version=test2 && find . -name "test.tex" && grep test2 test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --define No Pass"
    rm -f test.tex
    sgml2latex test.sgml -D version=test2 && find . -name "test.tex" && grep test2 test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -D No Pass"
    rm -f test.tex
    linuxdoc -B lyx test.sgml --define=version=test2 && find . -name "test.lyx" && grep test2 test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx --define No Pass"
    rm -f test.lyx
    linuxdoc -B lyx test.sgml -D version=test2 && find . -name "test.lyx" && grep test2 test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx -D No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml --define=version=test2 && find . -name "test.lyx" && grep test2 test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx --define No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml -D version=test2 && find . -name "test.lyx" && grep test2 test.lyx
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx -D No Pass"
    rm -f test.lyx
    linuxdoc -B rtf test.sgml --define=version=test2 && find . -name "test.rtf" && grep test2 test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --define No Pass"
    rm -f test.rtf
    linuxdoc -B rtf test.sgml -D version=test2 && find . -name "test.rtf" && grep test2 test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -D No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml --define=version=test2 && find . -name "test.rtf" && grep test2 test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --define No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml -D version=test2 && find . -name "test.rtf" && grep test2 test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -D No Pass"
    rm -f test.rtf
    linuxdoc -B rtf test.sgml --define=version=test2 && find . -name "test.rtf" && grep test2 test.rtf
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --define No Pass"
    rm -f test.rtf
    linuxdoc -B txt test.sgml -D version=test2 && find . -name "test.txt" && grep test2 test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -D No Pass"
    rm -f test.txt
    sgml2txt test.sgml --define=version=test2 && find . -name "test.txt" && grep test2 test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --define No Pass"
    rm -f test.txt
    sgml2txt test.sgml -D version=test2 && find . -name "test.txt" && grep test2 test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -D No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_07."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
