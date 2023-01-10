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

    db2x_docbook2texi --string-param custom-localization-file= --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --encoding --string-param custom-localization-file --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param custom-n-data=xml --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param custom-n-data --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param author-othername-in-middle=1 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param author-othername-in-middle --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param output-file= --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param output-file --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param directory-category= --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param directory-category --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param directory-description= --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param directory-description --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param index-category=cp --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param index-category --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param qanda-defaultlabel=0 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param qanda-defaultlabel --sgml failed"

    rm -rf untitled.texi
    db2x_docbook2texi --string-param qandaset-generate-toc=0 --sgml doctest/manpage.xsl && test -f untitled.texi
    CHECK_RESULT $? 0 0 "Check db2x_docbook2texi --string-param qandaset-generate-toc --sgml failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest untitled.texi
    LOG_INFO "Finish restore the test environment."
}

main "$@"
