#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   lufei
#@Contact       :   lufei@uniontech.com
#@Date          :   2026-03-16
#@License       :   Mulan PSL v2
#@Desc          :   Test case for newgrp command
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    
    LOG_INFO "Start to prepare the test environment."
    TEST_GROUP="testgrp_$(date +%Y%m%d%H%M%S)"
    groupadd "${TEST_GROUP}"
    TEST_GID=$(getent group ${TEST_GROUP} | cut -d: -f3)
    LOG_INFO "create test group with name ${TEST_GROUP}, id ${TEST_GID}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    
    LOG_INFO "Start to run test."

    echo "exit" | newgrp "${TEST_GROUP}"
    CHECK_RESULT $? 0 0 "Failed to switch to test group ${TEST_GROUP}"

    real_gid=$(newgrp "$TEST_GROUP" << EOF
id -g
EOF
)
    CHECK_RESULT $? 0 0 "Failed to switch to previous group"
    test "$real_gid" -eq "$TEST_GID"
    CHECK_RESULT $? 0 0 "id -g show different gid from $TEST_GID"

    LOG_INFO "End to run test."
}

function post_test() {
    
    LOG_INFO "Start to restore the test environment."
    groupdel "${TEST_GROUP}"
    LOG_INFO "End to restore the test environment."
}

main "$@"
