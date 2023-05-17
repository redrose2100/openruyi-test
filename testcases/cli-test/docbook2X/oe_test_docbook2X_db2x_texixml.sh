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

    db2x_texixml --output-dir ./doctest --encoding utf-8 doctest/chunk.xsl --info --to-stdout | grep "End Tag Table"
    CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --info --to-stdout failed"

    rm -rf doctest/chunk.xsl.txt
    db2x_texixml --output-dir ./doctest --encoding utf-8 doctest/chunk.xsl --list-files && test -f doctest/chunk.xsl.texi
    CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --list-files failed"

    rm -rf doctest/chunk.xsl.txt
    db2x_texixml --output-dir ./doctest --encoding utf-8 doctest/chunk.xsl --plaintext && test -f doctest/chunk.xsl.txt
    CHECK_RESULT $? 0 0 "Check db2x_texixml --output-dir --encoding --plaintext failed"

    rm -rf doctest/chunk.xsl.txt
    db2x_texixml --encoding utf-8 --utf8trans-program=./doctest --utf8trans-map=./doctest --iconv-program=./doctest --makeinfo-program=./doctest doctest/chunk.xsl && test -f chunk.xsl.texi
    CHECK_RESULT $? 0 0 "Check db2x_texixml --encoding --utf8trans-program --utf8trans-map --iconv-program --makeinfo-program failed"

    db2x_texixml --help | grep "Usage: /usr/bin/db2x_texixml \[OPTION]"
    CHECK_RESULT $? 0 0 "Check db2x_texixml --help failed"

    db2x_texixml --version | grep "db2x_texixml (part of docbook2X [[:digit:]].*)"
    CHECK_RESULT $? 0 0 "Check db2x_texixml --version failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest chunk.xsl.texi
    LOG_INFO "Finish restore the test environment."
}

main "$@"
