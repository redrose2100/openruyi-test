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
    ### -B latex -t ##
	linuxdoc -B latex test.sgml -t 4 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -t No Pass"
	rm -f test.tex
	### -B latex --debug ##
	linuxdoc -B latex test.sgml --debug && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --debug No Pass"
	rm -f test.tex
	### -B latex -d ##
	linuxdoc -B latex test.sgml -d && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -d No Pass"
	rm -f test.tex
	### -B latex --define ##
	linuxdoc -B latex test.sgml --define=version=1.0 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --define No Pass"
	rm -f test.tex
	### -B latex -D ##
	linuxdoc -B latex test.sgml -D version=1.0 && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -D No Pass"
	rm -f test.tex	
	### -B latex --include ##
	linuxdoc -B latex test.sgml --include=a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --include No Pass"
	rm -f test.tex
	### -B latex -i ##
	linuxdoc -B latex test.sgml -i a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -i No Pass"
	rm -f test.tex
	### -B latex --pass ##
	linuxdoc -B latex test.sgml --pass=a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex --pass No Pass"
	rm -f test.tex
	### -B latex -P ##
	linuxdoc -B latex test.sgml -P a && find . -name "test.tex"
	CHECK_RESULT $? 0 0 "L$LINENO: -B latex -P No Pass"
	rm -f test.tex
	### -B latex --output ##
    linuxdoc -B latex --output=tex test.sgml && find . -name "test.tex"
    CHECK_RESULT $? 0 0 "L$LINENO: -B latex --output No Pass"
    rm -f test.tex
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
