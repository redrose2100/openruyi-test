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
	### -B rtf --include ##
	linuxdoc -B rtf test.sgml --include=a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --include No Pass"
	rm -f test.rtf
	### -B rtf -i ##
	linuxdoc -B rtf test.sgml -i a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -i No Pass"
	rm -f test.rtf
	### -B rtf --pass ##
	linuxdoc -B rtf test.sgml --pass=a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --pass No Pass"
	rm -f test.rtf
	### -B rtf -P ##
	linuxdoc -B rtf test.sgml -P a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -P No Pass"
	rm -f test.rtf
	### -B rtf --twosplit ##
	linuxdoc -B rtf test.sgml --twosplit && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --twosplit No Pass"
	rm -f test.rtf
	### -B rtf -2 ##
	linuxdoc -B rtf test.sgml -2 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -2 No Pass"
	rm -f test.rtf
	### -B txt ##
	linuxdoc -B txt test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt No Pass"
	rm -f test.txt
	### --backend=txt ##
	linuxdoc --backend=txt test.sgml  && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: --backend=txt No Pass"
	rm -f test.txt
	### -B txt --papersize ##
	linuxdoc -B txt test.sgml --papersize=a4 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --papersize No Pass"
	rm -f test.txt
	### -B txt -p ##
	linuxdoc -B txt test.sgml -p a4 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -p No Pass"
	rm -f test.txt
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
