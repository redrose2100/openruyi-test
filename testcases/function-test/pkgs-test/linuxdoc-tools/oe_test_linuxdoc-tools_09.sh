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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_09."
    linuxdoc -B html test.sgml --dosnames && find . -name "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --dosnames No Pass"
    rm -f test.htm
    linuxdoc -B html test.sgml -h && find . -name "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -h No Pass"
    rm -f test.htm
    sgml2html test.sgml --dosnames && find . -name "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --dosnames No Pass"
    rm -f test.htm
    sgml2html test.sgml -h && find . -name "test.htm"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -h No Pass"
    rm -f test.htm
    linuxdoc -B html test.sgml --imagebuttons && find . -name "test.html" && grep "IMG" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --imagebuttons No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -I && find . -name "test.html" && grep "IMG" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -I No Pass"
    rm -f test.html
    sgml2html test.sgml --imagebuttons && find . -name "test.html" && grep "IMG" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --imagebuttons No Pass"
    rm -f test.html
    sgml2html test.sgml -I && find . -name "test.html" && grep "IMG" test.html
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -I No Pass"
    rm -f test.html
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_09."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
