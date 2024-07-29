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
# @Author    :   xuewenzhen
# @Contact   :   xuewenzhen1@huawei-partners.com
# @Date      :   2024.7.29
# @License   :   Mulan PSL v2
# @Desc      :   test the xmlcatalog can be used regularly
# ############################################
# shellcheck disable=SC1091,SC1017

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "End to prepare the test environment."
    DNF_INSTALL "libxml2-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # test01: xmlcatalog
    xmlcatalog --sgml --add 'entry' SGML > xml2test
    CHECK_RESULT $? 0 0 "Return value error"
    test "$(awk '{print $2}' xml2test)"=SGML
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