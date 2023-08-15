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
	### -B lyx --include ##
	linuxdoc -B lyx test.sgml --include=a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --include No Pass"
	rm -f test.lyx
	### -B lyx -i ##
	linuxdoc -B lyx test.sgml -i a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -i No Pass"
	rm -f test.lyx
	### -B lyx --pass ##
	linuxdoc -B lyx test.sgml --pass=a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx --pass No Pass"
	rm -f test.lyx
	### -B lyx -P ##
	linuxdoc -B lyx test.sgml -P a && find . -name "test.lyx"
	CHECK_RESULT $? 0 0 "L$LINENO: -B lyx -P No Pass"
	rm -f test.lyx
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
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
