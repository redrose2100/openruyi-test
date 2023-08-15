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
	DNF_INSTALL "texinfo"
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
    ### -B info ##
	linuxdoc -B info test.sgml && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info No Pass"
	rm -f test.info
	### --backend=info ##
	linuxdoc --backend=info test.sgml && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: --backend=info No Pass"
	rm -f test.info
	### -B info --papersize ##
	linuxdoc -B info test.sgml --papersize=a4 && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info --papersize No Pass"
	rm -f test.info
	### -B info -p ##
	linuxdoc -B info test.sgml -p a4 && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info -p No Pass"
	rm -f test.info
	### -B info --language ##
	linuxdoc -B info test.sgml --language=en && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info --language No Pass"
	rm -f test.info
	### -B info --charset ##
	linuxdoc -B info test.sgml --charset=utf-8 && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info --charset No Pass"
	rm -f test.info
	### -B info -c ##
	linuxdoc -B info test.sgml -c utf-8 && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info -c No Pass"
	rm -f test.info
	### -B info --style ##
	linuxdoc -B info test.sgml --style=a && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info --style No Pass"
	rm -f test.info
	### -B info -S ##
	linuxdoc -B info test.sgml -S a && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info -S No Pass"
	rm -f test.info
	### -B info --tabsize ##
	linuxdoc -B info test.sgml --tabsize=4 && find . -name "test.info"
	CHECK_RESULT $? 0 0 "L$LINENO: -B info --tabsize No Pass"
	rm -f test.info
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
	rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
