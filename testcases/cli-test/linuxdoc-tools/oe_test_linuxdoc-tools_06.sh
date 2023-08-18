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
	LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_06."
	### -B latex ##
	linuxdoc -B latex test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex No Pass"
	rm -f test.tex
	### --backend=latex ##
	linuxdoc --backend=latex test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: --backend=latex No Pass"
	rm -f test.tex
	### -B latex --papersize ##
	linuxdoc -B latex test.sgml --papersize=a4 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --papersize No Pass"
	rm -f test.tex
	### -B latex -p ##
	linuxdoc -B latex test.sgml -p a4 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -p No Pass"
	rm -f test.tex
	### -B latex --language ##
	linuxdoc -B latex test.sgml --language=en && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --language No Pass"
	rm -f test.tex
	### -B latex --charset ##
	linuxdoc -B latex test.sgml --charset=utf-8 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --charset No Pass"
	rm -f test.tex
	### -B latex -c ##
	linuxdoc -B latex test.sgml -c utf-8 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -c No Pass"
	rm -f test.tex
	### -B latex --style ##
	linuxdoc -B latex test.sgml --style=a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --style No Pass"
	rm -f test.tex
	### -B latex -S ##
	linuxdoc -B latex test.sgml -S a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -S No Pass"
	rm -f test.tex
	### -B latex --tabsize ##
	linuxdoc -B latex test.sgml --tabsize=4 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --tabsize No Pass"
	rm -f test.tex
	### -B latex -t ##
	linuxdoc -B latex test.sgml -t 4 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -t No Pass"
	rm -f test.tex
	LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_06."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE "$@"
	rm -f test.sgml
	LOG_INFO "End to restore the test environment."
}

main "$@"
