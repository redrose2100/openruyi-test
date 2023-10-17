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
<sect>a
<sect1>b</sect1>
<sect1>c</sect1>
</sect>
</article>
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_08."
    linuxdoc -B html test.sgml --split=2 && find . -name "test-3.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --split No Pass"
    rm -f test.html test-1.html test-2.html test-3.html
    linuxdoc -B html test.sgml -s 2 && find . -name "test-3.html"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -s No Pass"
    rm -f test.html test-1.html test-2.html test-3.html
    sgml2html test.sgml --split=2 && find . -name "test-3.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --split No Pass"
    rm -f test.html test-1.html test-2.html test-3.html
    sgml2html test.sgml -s 2 && find . -name "test-3.html"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -s No Pass"
    rm -f test.html test-1.html test-2.html test-3.html
    linuxdoc -B html test.sgml --toc=0 && find . -name "test.html" && ! (grep 1.1 test.html)
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --toc No Pass"
    rm -f test.html test-1.html
    linuxdoc -B html test.sgml -T 0 && find . -name "test.html" && ! (grep 1.1 test.html)
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -T No Pass"
    rm -f test.html test-1.html
    sgml2html test.sgml --toc=0 && find . -name "test.html" && ! (grep 1.1 test.html)
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --toc No Pass"
    rm -f test.html test-1.html
    sgml2html test.sgml -T 0 && find . -name "test.html" && ! (grep 1.1 test.html)
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -T No Pass"
    rm -f test.html test-1.html
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_08."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
