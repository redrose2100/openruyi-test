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
#@Author    :   liaoyuankun
#@Contact   :   1561203725@qq.com
#@Date      :   2023/8/05
#@License   :   Mulan PSL v2
#@Desc      :   Test "texi2html" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "texi2html"
    mkdir result
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."

    texi2html -h | grep -E "Usage: texi2html"
    CHECK_RESULT $? 0 0 "L$LINENO: -h No Pass"

    version=$(rpm -qa texi2html | awk -F "-" '{print$2}')
    test "$(texi2html -version)" == "$version"
    CHECK_RESULT $? 0 0 "L$LINENO: -version No Pass"

    texi2html -docbook -o=result/docb.xml common/test && grep -E "docbookx" result/docb.xml
    CHECK_RESULT $? 0 0 "L$LINENO: -docbook No Pass"

    texi2html -menu -o=result/menu.html common/test && find . -name "menu.html" | grep menu.html
    CHECK_RESULT $? 0 0 "L$LINENO: -menu No Pass"

    texi2html -info -o=result/info.info common/test && grep -E "This is info.info" result/info.info
    CHECK_RESULT $? 0 0 "L$LINENO: -info No Pass"

    texi2html -xml -o=result/ common/test && grep -E "xml:lang" result/test.xml
    CHECK_RESULT $? 0 0 "L$LINENO: -xml No Pass"

    texi2html -ifdocbook -o=result/ifdoc.html common/test && grep "ifdocbook_example" result/ifdoc.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifdocbook No Pass"
    rm -f test.html

    texi2html -ifhtml -o=result/ifhtml.html common/test && grep "ifhtml_example" result/ifhtml.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifhtml No Pass"
    rm -f test.html

    texi2html -ifinfo -o=result/ifin.html common/test && grep "ifinfo_example" result/ifin.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifinfo No Pass"
    rm -f test.html

    texi2html -ifplaintext -o=result/ifpl.html common/test && grep "ifplaintext_example" result/ifpl.html
    CHECK_RESULT $? 0 0 "L$LINENO: -ifplaintext No Pass"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf result
    LOG_INFO "End to restore the test environment."
}

main "$@"
