# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   hua
# @Contact   :   dchang@zhixundn.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of docbook2X command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL docbook2X
    cp -r common doctest
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    db2x_docbook2man --encoding utf-8 --string-param uppercase-headings=1 --sgml --solinks doctest/manpages.xml
    grep ".g .mso www.tmac" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param uppercase-headings --sgml failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param manvolnum-cite-numeral-only=1 --sgml doctest/manpages.xml
    fgrep ".if (\nx>(\n(.l/2))" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param manvolnum-cite-numeral-only failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param quotes-on-literals=0 --sgml --solinks doctest/manpages.xml
    grep ".g .mso www.tmac" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param quotes-on-literals failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param show-comments=1 --sgml --solinks doctest/manpages.xml
    fgrep ".if (\nx>(\n(.l/2))" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param show-comments failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param function-parens=0 --sgml --solinks doctest/manpages.xml
    fgrep "'in \n(.iu-\nxu" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param function-parens failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param xref-on-link=1 --sgml --solinks doctest/manpages.xml
    fgrep ".if \n(.g .ds T<" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param xref-on-link failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param header-3= --sgml --solinks doctest/manpages.xml
    fgrep ".if \n(.g .ds T<" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-3 failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param header-4= --sgml --solinks doctest/manpages.xml
    fgrep "'in \n(.iu-\nxu" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-4 failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param header-5= --sgml --solinks doctest/manpages.xml
    fgrep ".if \n(.g .ds T>" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param header-5 failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param default-manpage-section=1 --sgml --solinks doctest/manpages.xml
    fgrep ".if \n(.g .ds T>" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param default-manpage-section failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest docbook2man.1 _.1 '_manxml;.1'
    LOG_INFO "Finish restore the test environment."
}

main "$@"
