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
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026/07/15
# @License   :   Mulan PSL v2
# @Desc      :   Verify tbb package installation and parallel computing functionality
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tbb tbb-devel gcc-c++"
    TEST_TMP_DIR=$(mktemp -d /tmp/tbb_test_XXXXXX)
    export TEST_TMP_DIR
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    # 1. Verify tbb package is installed correctly
    rpm -q tbb > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to install tbb package"
    # 2. Verify tbb version information is available
    rpm -q tbb --queryformat '%{VERSION}' | grep -E "[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "Failed to query tbb version"
    # 3. Verify main tbb header file exists (core header)
    test -f /usr/include/tbb/tbb.h
    CHECK_RESULT $? 0 0 "tbb main header file tbb.h missing"
    # 4. Verify tbb shared library exists (runtime library)
    test -f /usr/lib64/libtbb.so || test -f /usr/lib/libtbb.so
    CHECK_RESULT $? 0 0 "tbb shared library libtbb.so missing"
    # 5. Copy TBB test source file to /tmp for compilation
    SRC_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)/common/tbb_test.c"
    cp -f "${SRC_PATH}" "${TEST_TMP_DIR}/tbb_test.c"
    CHECK_RESULT $? 0 0 "Failed to copy tbb test source file"
    # 6. Compile TBB test program with g++ and link against tbb library
    g++ -o "${TEST_TMP_DIR}/tbb_test" "${TEST_TMP_DIR}/tbb_test.c" -ltbb -std=c++17
    CHECK_RESULT $? 0 0 "Failed to compile tbb test program"
    # 7. Execute TBB parallel computing test program and save output
    "${TEST_TMP_DIR}/tbb_test" > "${TEST_TMP_DIR}/tbb_test_out.txt"
    CHECK_RESULT $? 0 0 "Failed to run tbb test program"
    # 8. Verify parallel_for functionality: parallel loop iteration
    grep "PASS: parallel_for" "${TEST_TMP_DIR}/tbb_test_out.txt"
    CHECK_RESULT $? 0 0 "tbb parallel_for test failed"
    # 9. Verify parallel_reduce functionality: parallel sum calculation
    grep "PASS: parallel_reduce" "${TEST_TMP_DIR}/tbb_test_out.txt"
    CHECK_RESULT $? 0 0 "tbb parallel_reduce test failed"
    # 10. Verify parallel_sort functionality: parallel sorting
    grep "PASS: parallel_sort" "${TEST_TMP_DIR}/tbb_test_out.txt"
    CHECK_RESULT $? 0 0 "tbb parallel_sort test failed"
    # 11. Verify concurrent_vector functionality: thread-safe vector container
    grep "PASS: concurrent_vector" "${TEST_TMP_DIR}/tbb_test_out.txt"
    CHECK_RESULT $? 0 0 "tbb concurrent_vector test failed"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start environment cleanup."
    rm -rf "${TEST_TMP_DIR}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
