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
	LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_11."
	### -B rtf ##
	linuxdoc -B rtf test.sgml && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf No Pass"
	rm -f test.rtf
	### --backend=rtf ##
	linuxdoc --backend=rtf test.sgml  && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: --backend=rtf No Pass"
	rm -f test.rtf
	### -B rtf --papersize ##
	linuxdoc -B rtf test.sgml --papersize=a4 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --papersize No Pass"
	rm -f test.rtf
	### -B rtf -p ##
	linuxdoc -B rtf test.sgml -p a4 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -p No Pass"
	rm -f test.rtf
	### -B rtf --language ##
	linuxdoc -B rtf test.sgml --language=en && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --language No Pass"
	rm -f test.rtf
	### -B rtf --charset ##
	linuxdoc -B rtf test.sgml --charset=utf-8 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --charset No Pass"
	rm -f test.rtf
	### -B rtf -c ##
	linuxdoc -B rtf test.sgml -c utf-8 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -c No Pass"
	rm -f test.rtf
	### -B rtf --style ##
	linuxdoc -B rtf test.sgml --style=a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --style No Pass"
	rm -f test.rtf
	### -B rtf -S ##
	linuxdoc -B rtf test.sgml -S a && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -S No Pass"
	rm -f test.rtf
	### -B rtf --tabsize ##
	linuxdoc -B rtf test.sgml --tabsize=4 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --tabsize No Pass"
	rm -f test.rtf
	### -B rtf -t ##
	linuxdoc -B rtf test.sgml -t 4 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -t No Pass"
	rm -f test.rtf
	LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_11."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
