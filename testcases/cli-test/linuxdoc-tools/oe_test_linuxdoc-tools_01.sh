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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_01."
    linuxdoc -B check test.sgml
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B check No Pass"
    sgmlcheck test.sgml
    CHECK_RESULT $? 0 0 "L$LINENO: sgmlcheck No Pass"
    linuxdoc -B html test.sgml && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html No Pass"
    rm -f test.html
    linuxdoc --backend=html test.sgml && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=html No Pass"
    rm -f test.html
    sgml2html test.sgml && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html No Pass"
    rm -f test.html
    linuxdoc -B info test.sgml && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info No Pass"
    rm -f test.info
    linuxdoc --backend=info test.sgml && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=info No Pass"
    rm -f test.info
    sgml2info test.sgml && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info No Pass"
    rm -f test.info
    linuxdoc -B latex test.sgml && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex No Pass"
    rm -f test.tex
    linuxdoc --backend=latex test.sgml && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=latex No Pass"
    rm -f test.tex
    sgml2latex test.sgml && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex No Pass"
    rm -f test.tex
    linuxdoc -B lyx test.sgml && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx No Pass"
    rm -f test.lyx
    linuxdoc --backend=lyx test.sgml  && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=lyx No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx No Pass"
    rm -f test.lyx
    linuxdoc -B rtf test.sgml && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf No Pass"
    rm -f test.rtf
    linuxdoc --backend=rtf test.sgml && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=rtf No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf No Pass"
    rm -f test.rtf
    linuxdoc -B txt test.sgml && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt No Pass"
    rm -f test.txt
    linuxdoc --backend=txt test.sgml && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc --backend=txt No Pass"
    rm -f test.txt
    sgml2txt test.sgml && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_01."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
