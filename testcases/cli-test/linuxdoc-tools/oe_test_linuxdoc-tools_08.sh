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
	LOG_INFO "Start to run testcase:oe_test_linuxdoc-tools_08."
	### -B latex --makeindex ##
    linuxdoc -B latex --makeindex  test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --makeindex No Pass"
	rm -f test.tex
	### -B latex -m ##
	linuxdoc -B latex -m test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -m No Pass"
	rm -f test.tex
	### -B latex --pagenumber ##
	linuxdoc -B latex --pagenumber=1  test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --pagenumber No Pass"
	rm -f test.tex
	### -B latex -n ##
	linuxdoc -B latex -n 1  test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -n No Pass"
	rm -f test.tex
	### -B latex --quick ##
	linuxdoc -B latex --quick  test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --quick No Pass"
	rm -f test.tex
	### -B latex -q ##
	linuxdoc -B latex -q test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -q No Pass"
	rm -f test.tex
	### -B latex --dvips ##
	linuxdoc -B latex --dvips=dvi2ps test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --dvips No Pass"
	rm -f test.tex
	### -B latex -s ##
	linuxdoc -B latex -s dvi2ps test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -s No Pass"
	rm -f test.tex
	### -B latex --latex ##
	linuxdoc -B latex --latex=latex test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --latex No Pass"
	rm -f test.tex
	### -B latex -x ##
	linuxdoc -B latex -x latex test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -x No Pass"
	rm -f test.tex
	### -B latex --verbosity ##
	linuxdoc -B latex --verbosity=1 test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --verbosity No Pass"
	rm -f test.tex
	### -B latex -V ##
	linuxdoc -B latex -V 1 test.sgml && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -V No Pass"
	rm -f test.tex
	LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_08."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE "$@"
	rm -f test.sgml
	LOG_INFO "End to restore the test environment."
}

main "$@"
