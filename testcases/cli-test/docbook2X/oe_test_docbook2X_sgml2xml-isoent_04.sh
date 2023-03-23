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

    sgml2xml-isoent -b utf-8 --warning=default doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --warning failed"

    sgml2xml-isoent -b utf-8 -x empty doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -x failed"

    sgml2xml-isoent -b utf-8 --xml-output-option=empty doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --xml-output-option failed"

    sgml2xml-isoent -b utf-8 -d empty doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -d failed"

    sgml2xml-isoent -b utf-8 --entity_output_location=empty doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --entity_output_location failed"

    sgml2xml-isoent -b utf-8 -l empty doctest/hello.sgml | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent -l failed"

    sgml2xml -b utf-8 -f doctest/error --dtd_location=empty doctest/test1.sgml | grep "<NOTHING"
    CHECK_RESULT $? 0 0 "Check sgml2xml-isoent --dtd_location failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf doctest
    LOG_INFO "Finish restore the test environment."
}

main "$@"
