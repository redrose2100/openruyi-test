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
<sect>a</sect>
</article>
EOF
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_13."
    linuxdoc -B txt test.sgml --manpage && find . -name "test.man"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --manpage No Pass"
    rm -f test.man
    linuxdoc -B txt test.sgml -m && find . -name "test.man"
	CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --m No Pass"
	rm -f test.man
    sgml2txt test.sgml -manpage && find . -name "test.man"
	CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --manpage No Pass"
	rm -f test.man
    sgml2txt test.sgml -m && find . -name "test.man"
	CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --m No Pass"
	rm -f test.man
    linuxdoc -B txt test.sgml --filter && find . -name "test.txt" && grep "1." test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --filter No Pass"
    rm -f test.txt
    linuxdoc -B txt test.sgml -f && find . -name "test.txt" && grep "1." test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -f No Pass"
    rm -f test.txt
    sgml2txt test.sgml --filter && find . -name "test.txt" && grep "1." test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --filter No Pass"
    rm -f test.txt
    sgml2txt test.sgml -f && find . -name "test.txt" && grep "1." test.txt
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -f No Pass"
    rm -f test.txt
    linuxdoc -B txt test.sgml --blanks=1 && find . -name "test.txt" && head -4 test.txt | grep "This"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt --blanks No Pass"
    rm -f test.txt
    linuxdoc -B txt test.sgml -b 1 && find . -name "test.txt" && head -4 test.txt | grep "This"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B txt -b No Pass"
    rm -f test.txt
    sgml2txt test.sgml --blanks=1 && find . -name "test.txt" && head -4 test.txt | grep "This"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt --blanks No Pass"
    rm -f test.txt
    sgml2txt test.sgml -b 1 && find . -name "test.txt" && head -4 test.txt | grep "This"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2txt -b No Pass"
    rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_13."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
