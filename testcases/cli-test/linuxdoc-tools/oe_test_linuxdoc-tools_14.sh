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
	### -B txt --language ##
	linuxdoc -B txt test.sgml --language=en && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --language No Pass"
	rm -f test.txt
	### -B txt --charset ##
	linuxdoc -B txt test.sgml --charset=utf-8 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --charset No Pass"
	rm -f test.txt
	### -B txt -c ##
	linuxdoc -B txt test.sgml -c utf-8 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -c No Pass"
	rm -f test.txt
	### -B txt --style ##
	linuxdoc -B txt test.sgml --style=a && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --style No Pass"
	rm -f test.txt
	### -B txt -S ##
	linuxdoc -B txt test.sgml -S a && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -S No Pass"
	rm -f test.txt
	### -B txt --tabsize ##
	linuxdoc -B txt test.sgml --tabsize=4 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt --tabsize No Pass"
	rm -f test.txt
	### -B txt -t ##
	linuxdoc -B txt test.sgml -t 4 && find . -name "test.txt"
	CHECK_RESULT $? 0 0 "L$LINENO: -B txt -t No Pass"
	rm -f test.txt
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
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
