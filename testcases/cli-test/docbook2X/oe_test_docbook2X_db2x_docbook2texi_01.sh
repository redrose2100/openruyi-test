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

    db2x_docbook2texi --encoding utf-8 --string-param captions-display-as-headings=0 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --encoding --string-param captions-display-as-headings --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param links-use-pxref=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param links-use-pxref --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param explicit-node-names=0 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param explicit-node-names --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param show-comments=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param show-comment --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param funcsynopsis-decoration=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param funcsynopsis-decoration --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param function-parens=0 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param function-parens --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param refentry-display-name= --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param refentry-display-name --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param manvolnum-in-xref=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param manvolnum-in-xref --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param prefer-textobjects=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param prefer-textobjects --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param semantic-decorations=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param semantic-decorations --sgml failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest untitled.texi
    LOG_INFO "Finish restore the test environment."
}

main "$@"
