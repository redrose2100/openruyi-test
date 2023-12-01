#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
    linuxdoc -B latex test.sgml --output=pdf && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --output No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml -o pdf && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -o No Pass"
    rm -f test.pdf
    sgml2latex test.sgml --output=pdf && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --output No Pass"
    rm -f test.pdf
    sgml2latex test.sgml -o pdf && find . -name "test.pdf"
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -o No Pass"
    rm -f test.pdf
    linuxdoc -B latex test.sgml --makeindex && find . -name "test.tex" && grep makeindex test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --makeindex No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -m && find . -name "test.tex" && grep makeindex test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -m No Pass"
    rm -f test.tex
    sgml2latex test.sgml --makeindex && find . -name "test.tex" && grep makeindex test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --makeindex No Pass"
    rm -f test.tex
    sgml2latex test.sgml -m && find . -name "test.tex" && grep makeindex test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -m No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml --pagenumber=2 && find . -name "test.tex" && grep "{page}{2}" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex --pagenumber No Pass"
    rm -f test.tex
    linuxdoc -B latex test.sgml -n 2 && find . -name "test.tex" && grep "{page}{2}" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: linuxdoc -B latex -n No Pass"
    rm -f test.tex
    sgml2latex test.sgml --pagenumber=2 && find . -name "test.tex" && grep "{page}{2}" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex --pagenumber No Pass"
    rm -f test.tex
    sgml2latex test.sgml -n 2 && find . -name "test.tex" && grep "{page}{2}" test.tex
    CHECK_RESULT $? 0 0 "L$LINENO: sgml2latex -n No Pass"
    rm -f test.tex
    LOG_INFO "End to run testcase:oe_test_linuxdoc-tools_11."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f test.sgml
    LOG_INFO "End to restore the test environment."
}

main "$@"
