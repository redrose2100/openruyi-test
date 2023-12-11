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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_12."
    linuxdoc -B latex test.sgml -o pdf --verbosity=2 | grep -c "test.log" | grep 3 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --verbostiy No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf -V 2 | grep -c "test.log" | grep 3 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -V No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf --verbosity=2 | grep -c "test.log" | grep 3 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --verbostiy No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf -V 2 | grep -c "test.log" | grep 3 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -V No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf -V 2 --quick | grep -c "test.log" | grep 1 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --quick No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf -V 2 -q | grep -c "test.log" | grep 1 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -q No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf -V 2 --quick | grep -c "test.log" | grep 1 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --quick No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf -V 2 -q | grep -c "test.log" | grep 1 && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -q No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf -V 2 --bibtex | grep -E "BibTeX" && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --bibtex No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf -V 2 -b | grep -E "BibTeX" && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -b No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf -V 2 --bibtex | grep -E "BibTeX" && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --bibtex No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf -V 2 -b | grep -E "BibTeX" && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -b No Pass"
    rm -f test.pdf
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_12."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
