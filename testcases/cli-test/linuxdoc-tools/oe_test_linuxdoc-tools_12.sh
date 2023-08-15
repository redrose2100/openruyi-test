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
	### -B rtf --debug ##
	linuxdoc -B rtf test.sgml --debug && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --debug No Pass"
	rm -f test.rtf
	### -B rtf -d ##
	linuxdoc -B rtf test.sgml -d && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -d No Pass"
	rm -f test.rtf
	### -B rtf --define ##
	linuxdoc -B rtf test.sgml --define=version=1.0 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf --define No Pass"
	rm -f test.rtf
	### -B rtf -D ##
	linuxdoc -B rtf test.sgml -D version=1.0 && find . -name "test.rtf"
	CHECK_RESULT $? 0 0 "L$LINENO: -B rtf -D No Pass"
	rm -f test.rtf	
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
