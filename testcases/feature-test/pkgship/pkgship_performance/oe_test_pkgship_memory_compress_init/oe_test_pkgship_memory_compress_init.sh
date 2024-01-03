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
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-02-22
#@License   	:   Mulan PSL v2
#@Desc      	:   Test init when set memory stress
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    MEM_STRESS

    LOG_INFO "Finish to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship init -filepath ../../common_lib/openEuler.yaml | grep "Database initialize success"
    CHECK_RESULT $? 0 0 "pkgship init failed"
    SLEEP_WAIT 5
    pkgship dbs | grep openeuler-lts >/dev/null
    CHECK_RESULT $? 0 0 "pkgship dbs failed."

    LOG_INFO "Start to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    kill -9 "$(pgrep -a -f stress | grep -Ev "bash|grep|mugen.sh" | awk '{print $1}')"
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
