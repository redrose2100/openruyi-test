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

    sgml2xml-isoent --encoding=utf-8 --error-file=doctest/error doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --encoding --error-file failed"

    sgml2xml-isoent -b utf-8 -f doctest/error doctest/hello.sgml  | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -b -f failed"

    sgml2xml-isoent -v doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -v failed"

    sgml2xml-isoent --version doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --version failed"

    sgml2xml-isoent -h 2>&1 | grep "Usage: /usr/bin/sgml2xml \[OPTION]"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -h failed"

    sgml2xml-isoent --help 2>&1 | grep "Usage: /usr/bin/sgml2xml \[OPTION]"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --help failed"

    sgml2xml-isoent -b utf-8 -c doctest/1.log -E 10 doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -c -E failed"

    sgml2xml-isoent -b utf-8 --catalog=doctest/1.log -E 10 doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --catalog -E failed"

    sgml2xml-isoent -b utf-8 -C doctest/log doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -C failed"

    sgml2xml-isoent -b utf-8 --catalogs doctest/log doctest/hello.sgml | grep 'xml version="1.0" encoding="utf-8"'
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --catalogs failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
