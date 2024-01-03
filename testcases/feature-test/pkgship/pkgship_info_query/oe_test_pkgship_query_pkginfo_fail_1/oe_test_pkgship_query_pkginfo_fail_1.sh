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
#@Date      	:   2023-07-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Test QUERY_PKGINFO command without pkgName
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. Test QUERY_PKGINFO command with lacking arguments"

    # Lack package name
    QUERY_PKGINFO "" openeuler-lts 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking pkg name is false."
    QUERY_PKGINFO "" openeuler-lts -s 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking pkg name is false."

    # Lack dbname
    QUERY_PKGINFO git "" 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking dbname is false."
    QUERY_PKGINFO git "" -s 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking dbname is false."

    # Lack package name and dbname
    QUERY_PKGINFO "" "" 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking pkg name and dbname is false."
    QUERY_PKGINFO "" "" -s 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "The error message of lacking pkg name and dbname is false."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
