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
# @Date      :   2026/07/24
# @License   :   Mulan PSL v2
# @Desc      :   Test c-ares async DNS query API via compiled C program
# #############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    test_dir="/tmp/c-ares_test"
    src_file="${OET_PATH}/testcases/cli-test/c-ares/common/c-ares_test.c"
    bin_file="${test_dir}/c-ares_test"    
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "c-ares c-ares-devel gcc"
    mkdir -p "${test_dir}"
    # Compile the async DNS query test program against libcares
    gcc -fPIC -o "${bin_file}" "${src_file}" -lcares
    CHECK_RESULT $? 0 0 "failed to compile c-ares test program"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Verify async DNS query resolves localhost to 127.0.0.1
    "${bin_file}" localhost > "${test_dir}"/query_result.txt 2>&1
    CHECK_RESULT $? 0 0 "c-ares async query for localhost failed"
    grep -F "127.0.0.1" "${test_dir}"/query_result.txt
    CHECK_RESULT $? 0 0 "async query did not return 127.0.0.1 for localhost"

    # Verify async query for loopback address literal
    "${bin_file}" 127.0.0.1 > "${test_dir}"/query_ip.txt 2>&1
    CHECK_RESULT $? 0 0 "c-ares async query for 127.0.0.1 failed"
    grep -F "127.0.0.1" "${test_dir}"/query_ip.txt
    CHECK_RESULT $? 0 0 "async query did not return 127.0.0.1"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${test_dir}"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
