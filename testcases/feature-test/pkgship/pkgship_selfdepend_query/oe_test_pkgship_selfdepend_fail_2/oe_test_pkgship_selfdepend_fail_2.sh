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
#@Date      	:   2023-02-19
#@License   	:   Mulan PSL v2
#@Desc      	:   Test pkgship selfdepend command with lacking parameters
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

    pkgship selfdepend -dbs openEuler 2>&1 | grep "ERROR_CONTENT" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when set pkg = ''"

    pkgship selfdepend CUnit -b openEuler 2>&1 | grep -E "usage|error" >/dev/null
    CHECK_RESULT $? 0 0 "The message is error when query without -dbs"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
