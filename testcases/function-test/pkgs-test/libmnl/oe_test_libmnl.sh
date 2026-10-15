#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   cherry530
# @Contact   :   707078654@qq.com
# @Date      :   2026/07/22
# @License   :   Mulan PSL v2
# @Desc      :   Test libmnl netlink message construction, parsing and sockets
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/libmnl_test"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libmnl libmnl-devel gcc"
    mkdir -p "${TEST_DIR}"
    cp "${OET_PATH}/testcases/function-test/pkgs-test/libmnl/common/mnl_message.c" "${TEST_DIR}/mnl_message.c"
    CHECK_RESULT $? 0 0 "failed to copy the libmnl test program"
    LOG_INFO "End to run test."
}

function run_test() {
    LOG_INFO "Start to run test."

    rpm -q libmnl libmnl-devel
    CHECK_RESULT $? 0 0 "libmnl packages are not installed"

    gcc -Wall -Wextra -o "${TEST_DIR}/mnl_message" "${TEST_DIR}/mnl_message.c" -lmnl
    CHECK_RESULT $? 0 0 "failed to compile the libmnl API test program"

    "${TEST_DIR}/mnl_message" | grep -q "^MNL_RESULT message_and_socket_ok$"
    CHECK_RESULT $? 0 0 "libmnl message or socket API verification failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    DNF_REMOVE
    LOG_INFO "End to run test."
}

main "$@"
