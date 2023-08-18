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
	### -B html -t ##
	linuxdoc -B html test.sgml -t 4 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -t No Pass"
	rm -f test.html
	### -B html --debug ##
	linuxdoc -B html test.sgml --debug && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --debug No Pass"
	rm -f test.html
	### -B html -d ##
	linuxdoc -B html test.sgml -d && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -d No Pass"
	rm -f test.html
	### -B html --define ##
	linuxdoc -B html test.sgml --define=version=1.0 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --define No Pass"
	rm -f test.html
	### -B html -D ##
	linuxdoc -B html test.sgml -D version=1.0 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -D No Pass"
	rm -f test.html	
	### -B html --include ##
	linuxdoc -B html test.sgml --include=a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --include No Pass"
	rm -f test.html
	### -B html -i ##
	linuxdoc -B html test.sgml -i a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -i No Pass"
	rm -f test.html
	### -B html --pass ##
	linuxdoc -B html test.sgml --pass=a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --pass No Pass"
	rm -f test.html
	### -B html -P ##
	linuxdoc -B html test.sgml -P a && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html -P No Pass"
	rm -f test.html
	### -B html --split ##
	linuxdoc -B html test.sgml --split=0 && find . -name "test.html"
	CHECK_RESULT $? 0 0 "L$LINENO: -B html --split No Pass"
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
