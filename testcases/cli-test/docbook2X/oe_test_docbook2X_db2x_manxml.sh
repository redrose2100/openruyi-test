#!/usr/bin/bash

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

    db2x_manxml --output-dir ./doctest --encoding utf-8 doctest/manpage.xsl --no-links --to-stdout | grep ".g .mso www.tmac"
    CHECK_RESULT $? 0 0 "Check db2x_manxml --to-stdout failed"

    db2x_manxml --output-dir ./doctest --encoding utf-8 doctest/manpage.xsl --solinks --list-files && test -f doctest/'_.{$section}'
    CHECK_RESULT $? 0 0 "Check db2x_manxml --list-files failed"

    rm -rf doctest/'_.{$section}'
    db2x_manxml --output-dir ./doctest --encoding utf-8 doctest/manpage.xsl --symlinks && test -f doctest/'_.{$section}'
    CHECK_RESULT $? 0 0 "Check db2x_manxml --symlinks failed"

    rm -rf doctest/'_.{$section}'
    db2x_manxml --output-dir ./doctest --encoding utf-8 doctest/manpage.xsl --solinks && test -f doctest/'_.{$section}'
    CHECK_RESULT $? 0 0 "Check db2x_manxml --solinks failed"

    db2x_manxml --help | fgrep "Usage: /usr/bin/db2x_manxml [OPTION]"
    CHECK_RESULT $? 0 0 "Check db2x_manxml --help failed"

    db2x_manxml --version | grep "db2x_manxml (part of docbook2X [[:digit:]].*)"
    CHECK_RESULT $? 0 0 "Check db2x_manxml --version failed"

    db2x_manxml --encoding utf-8 --utf8trans-program=./doctest --utf8trans-map=./doctest --iconv-program=./doctest doctest/manpage.xsl && test -f ./'_.{$section}'
    CHECK_RESULT $? 0 0 "Check db2x_manxml --utf8trans-program --utf8trans-map= --iconv-program failed"

    db2x_docbook2man --string-param custom-localization-file= --sgml --solinks doctest/manpages.xml
    grep ".g .mso www.tmac" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param custom-localization-file failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param custom-n-data=text.xml --sgml --solinks doctest/manpages.xml
    grep ".g .mso www.tmac" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param custom-n-data failed"

    rm -rf docbook2man.1
    db2x_docbook2man --string-param author-othername-in-middle=1 --sgml --solinks doctest/manpages.xml
    grep ".g .mso www.tmac" ./docbook2man.1
    CHECK_RESULT $? 0 0 "Check db2x_docbook2man --string-param author-othername-in-middle failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest untitled.texi docbook2man.1 '_.{$section}'
    LOG_INFO "Finish restore the test environment."
}

main "$@"
