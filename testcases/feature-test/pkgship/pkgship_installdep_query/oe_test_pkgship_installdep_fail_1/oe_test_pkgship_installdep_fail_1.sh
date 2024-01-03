#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li,Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Test QUERY_INSTALLDEP command without critical binaryName
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    QUERY_INSTALLDEP "" openeuler 1 2>&1 | grep "ERROR_CONTENT"
    CHECK_RESULT $? 0 0 "The msg is false when no package name input."

    QUERY_INSTALLDEP CUnit openeuler " " 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The msg is false when no para input"

    QUERY_INSTALLDEP "" "" "" 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The msg is false when no parameters."
    
    pkgship installdep git -dbs openeuler 1 2>&1 | grep "Request parameter error"
    CHECK_RESULT $? 0 0 "The msg is false when no -level."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
