#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools."
	### -B check ##
	linuxdoc -B check test.sgml
	CHECK_RESULT $? 0 0 "L$LINENO: -B check No Pass"
    ### -B html ##
	linuxdoc -B html test.sgml && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html No Pass"
	rm -f test.html
	### --backend=html ##
	linuxdoc --backend=html test.sgml  && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: --backend=html No Pass"
	rm -f test.html
	### -B html --papersize ##
	linuxdoc -B html test.sgml --papersize=a4 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --papersize No Pass"
	rm -f test.html
	### -B html -p ##
	linuxdoc -B html test.sgml -p a4 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -p No Pass"
	rm -f test.html
	### -B html --language ##
	linuxdoc -B html test.sgml --language=en && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --language No Pass"
	rm -f test.html
	### -B html --charset ##
	linuxdoc -B html test.sgml --charset=utf-8 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --charset No Pass"
	rm -f test.html
	### -B html -c ##
	linuxdoc -B html test.sgml -c utf-8 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -c No Pass"
	rm -f test.html
	### -B html --style ##
	linuxdoc -B html test.sgml --style=a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --style No Pass"
	rm -f test.html
	### -B html -S ##
	linuxdoc -B html test.sgml -S a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -S No Pass"
	rm -f test.html
	### -B html --tabsize ##
	linuxdoc -B html test.sgml --tabsize=4 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --tabsize No Pass"
	rm -f test.html
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
