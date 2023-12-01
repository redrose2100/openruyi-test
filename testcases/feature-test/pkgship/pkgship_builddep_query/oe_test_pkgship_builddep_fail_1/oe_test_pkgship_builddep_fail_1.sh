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
#@Date      	:   2021-02-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Test pkgship buildldep command without critical binaryName
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test. Execute cmd: pkgship builddep"

    pkgship builddep -dbs openEuler 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "Check failed when no pkg name"

    pkgship builddep git openEuler -dbs -level 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "Check failed when no level"

    pkgship builddep -dbs 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "Check failed when no parameter"

    pkgship builddep git -dbs openEuler 2 2>&1 | grep -E "usage|error"
    CHECK_RESULT $? 0 0 "Check failed when no -level"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
