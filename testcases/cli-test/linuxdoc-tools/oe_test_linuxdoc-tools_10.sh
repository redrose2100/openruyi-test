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
    echo "test" > add.txt
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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_10."
    linuxdoc -B html test.sgml --footer=add.txt && find . -name "test.html" && tail -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --footer No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -F add.txt && find . -name "test.html" && tail -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -F No Pass"
    rm -f test.html
    sgml2html test.sgml --footer=add.txt && find . -name "test.html" && tail -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --footer No Pass"
    rm -f test.html
    sgml2html test.sgml -F add.txt && find . -name "test.html" && tail -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -F No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml --header=add.txt && find . -name "test.html" && head -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html --header No Pass"
    rm -f test.html
    linuxdoc -B html test.sgml -H add.txt && find . -name "test.html" && head -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B html -H No Pass"
    rm -f test.html
    sgml2html test.sgml --header=add.txt && find . -name "test.html" && head -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html --header No Pass"
    rm -f test.html
    sgml2html test.sgml -H add.txt && find . -name "test.html" && head -n 1 test.html | grep "test"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2html -H No Pass"
    rm -f test.html
    linuxdoc -B txt test.sgml --pass=add.txt && find . -name "test.txt" && grep test test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --pass No Pass"
    rm -f test.txt
    linuxdoc -B txt test.sgml -P add.txt && find . -name "test.txt" && grep test test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -P No Pass"
    rm -f test.txt
    sgml2txt test.sgml --pass=add.txt && find . -name "test.txt" && grep test test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --pass No Pass"
    rm -f test.txt
    sgml2txt test.sgml -P add.txt && find . -name "test.txt" && grep test test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -P No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_10."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml add.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
