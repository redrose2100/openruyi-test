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
úù§ABD
</abstract>

</article>
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_03."
    linuxdoc -B html test.sgml --charset=latin && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --charset No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -c latin && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -c No Pass"
    rm -f test.html
    sgml2html test.sgml --charset=latin && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --charset No Pass"
    rm -f test.html
    sgml2html test.sgml -c latin && find . -name "test.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -c No Pass"
    rm -f test.html
    linuxdoc -B info test.sgml --charset=latin && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info --charset No Pass"
    rm -f test.info
    linuxdoc -B info test.sgml -c latin && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B info -c No Pass"
    rm -f test.info
    sgml2info test.sgml --charset=latin && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info --charset No Pass"
    rm -f test.info
    sgml2info test.sgml -c latin && find . -name "test.info"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2info -c No Pass"
    rm -f test.info
    linuxdoc -B latex test.sgml --charset=latin && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --charset No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -c latin && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -c No Pass"
    rm -f test.tex
    sgml2latex test.sgml --charset=latin && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --charset No Pass"
    rm -f test.tex
    sgml2latex test.sgml -c latin && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -c No Pass"
    rm -f test.tex
    linuxdoc -B lyx test.sgml --charset=latin && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx --charset No Pass"
    rm -f test.lyx
    linuxdoc -B lyx test.sgml -c latin && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B lyx -c No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml --charset=latin && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx --charset No Pass"
    rm -f test.lyx
    sgml2lyx test.sgml -c latin && find . -name "test.lyx"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2lyx -c No Pass"
    rm -f test.lyx
    linuxdoc -B rtf test.sgml --charset=latin && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf --charset No Pass"
    rm -f test.rtf
    linuxdoc -B rtf test.sgml -c latin && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B rtf -c No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml --charset=latin && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf --charset No Pass"
    rm -f test.rtf
    sgml2rtf test.sgml -c latin && find . -name "test.rtf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2rtf -c No Pass"
    rm -f test.rtf
    linuxdoc -B txt test.sgml --charset=latin && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --charset No Pass"
    rm -f test.txt
    linuxdoc -B txt test.sgml -c latin && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -c No Pass"
    rm -f test.txt
    sgml2txt test.sgml --charset=latin && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --charset No Pass"
    rm -f test.txt
    sgml2txt test.sgml -c latin && find . -name "test.txt"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -c No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_03."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
