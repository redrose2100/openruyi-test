#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   pengrui
# @Contact   :   pengrui@uniontech.com
# @Date      :   2023.4.3
# @License   :   Mulan PSL v2
# @Desc      :   test the xml2-config can be used regularly
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libxml2-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    xml2-config --help
    CHECK_RESULT $? 0 0 "Return value error"

    # test01: xml2-config --libs diaplay linked libs
    xml2-config --libs > xml2test
    CHECK_RESULT $? 0 0 "Return value error"
    [ "$(cat xml2test | awk -F '-' '{print $2}')" = "lxml2 " ]
    CHECK_RESULT $? 0 0 "Return value error"

    # test02：xml2-config --cflags display cflags
    test "$(xml2-config --cflags)" = "-I/usr/include/libxml2"
    CHECK_RESULT $? 0 0 "Return value error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf xml2test
    LOG_INFO "End to restore the test environment."
}

main "$@"