#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Test c-ares basic DNS lookup and asynchronous API
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the test environment."
    TEST_DIR="/tmp/c-ares_test"
    TEST_SOURCE="${OET_PATH}/testcases/cli-test/c-ares/common/test_cares.c"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "c-ares c-ares-devel gcc"
    mkdir -p "${TEST_DIR}"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    rpm -q c-ares c-ares-devel
    CHECK_RESULT $? 0 0 "c-ares packages are not installed"

    gcc -Wall -Wextra -o "${TEST_DIR}/test_cares" "${TEST_SOURCE}" -lcares
    CHECK_RESULT $? 0 0 "failed to compile the c-ares API test"

    "${TEST_DIR}/test_cares" | grep -q "^CARES_RESULT basic_dns_and_async_api_ok$"
    CHECK_RESULT $? 0 0 "c-ares basic DNS or asynchronous API verification failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
