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
	### -B lyx --charset ##
	linuxdoc -B lyx test.sgml --charset=utf-8 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --charset No Pass"
	rm -f test.lyx
	### -B lyx -c ##
	linuxdoc -B lyx test.sgml -c utf-8 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -c No Pass"
	rm -f test.lyx
	### -B lyx --style ##
	linuxdoc -B lyx test.sgml --style=a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --style No Pass"
	rm -f test.lyx
	### -B lyx -S ##
	linuxdoc -B lyx test.sgml -S a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -S No Pass"
	rm -f test.lyx
	### -B lyx --tabsize ##
	linuxdoc -B lyx test.sgml --tabsize=4 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --tabsize No Pass"
	rm -f test.lyx
	### -B lyx -t ##
	linuxdoc -B lyx test.sgml -t 4 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -t No Pass"
	rm -f test.lyx
	### -B lyx --debug ##
	linuxdoc -B lyx test.sgml --debug && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --debug No Pass"
	rm -f test.lyx
	### -B lyx -d ##
	linuxdoc -B lyx test.sgml -d && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -d No Pass"
	rm -f test.lyx
	### -B lyx --define ##
	linuxdoc -B lyx test.sgml --define=version=1.0 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --define No Pass"
	rm -f test.lyx
	### -B lyx -D ##
	linuxdoc -B lyx test.sgml -D version=1.0 && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -D No Pass"
	rm -f test.lyx	
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
