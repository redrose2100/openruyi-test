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
    LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_14."
	### -B txt --debug ##
	linuxdoc -B txt test.sgml --debug && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --debug No Pass"
	rm -f test.txt
	### -B txt -d ##
	linuxdoc -B txt test.sgml -d && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -d No Pass"
	rm -f test.txt
	### -B txt --define ##
	linuxdoc -B txt test.sgml --define=version=1.0 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --define No Pass"
	rm -f test.txt
	### -B txt -D ##
	linuxdoc -B txt test.sgml -D version=1.0 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -D No Pass"
	rm -f test.txt	
	### -B txt --include ##
	linuxdoc -B txt test.sgml --include=a && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --include No Pass"
	rm -f test.txt
	### -B txt -i ##
	linuxdoc -B txt test.sgml -i a && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -i No Pass"
	rm -f test.txt
	### -B txt --pass ##
	linuxdoc -B txt test.sgml --pass=test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --pass No Pass"
	rm -f test.txt
	### -B txt -P ##
	linuxdoc -B txt test.sgml -P test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -P No Pass"
	rm -f test.txt
	### -B txt --manpage ##
    linuxdoc -B txt --manpage test.sgml && find . -name "test.man"
    CHECK_RESULT $? 0 0 "L$LINENO: -B txt --manpage No Pass"
    rm -f test.man
	### -B txt -m ##
    linuxdoc -B txt -m test.sgml && find . -name "test.man"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --m No Pass"
	rm -f test.man
	### -B txt --filter ##
	linuxdoc -B txt --filter test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --filter No Pass"
	rm -f test.txt
	### -B txt -f ##
	linuxdoc -B txt -f test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -f No Pass"
	rm -f test.txt
	### -B txt --blanks ##
	linuxdoc -B txt --blanks=1 test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --blanks No Pass"
	rm -f test.txt
	### -B txt -b 1 ##
	linuxdoc -B txt -b 1 test.sgml && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -b No Pass"
	rm -f test.txt
	LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_14."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
