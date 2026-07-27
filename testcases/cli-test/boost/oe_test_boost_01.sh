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
# @Date      :   2026/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Verify boost package and filesystem sublibrary functions
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "boost-devel gcc-c++"
    TEST_TMP_DIR=$(mktemp -d /tmp/boost_test_XXXXXX) || { LOG_ERROR "mktemp failed"; exit 1; }
    export TEST_TMP_DIR
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q boost | grep "boost"
    CHECK_RESULT $? 0 0 "boost package not installed"
    rpm -V boost
    CHECK_RESULT $? 0 0 "boost package verification failed"
    rpm -qa boost | awk -F'-' '{print $2}' | grep -E "[0-9.]+"
    CHECK_RESULT $? 0 0 "Failed to get boost version"
    cp -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)/common/boost_test.c" "${TEST_TMP_DIR}/boost_test.c"
    CHECK_RESULT $? 0 0 "Failed to copy boost test source file"
    g++ -std=c++11 -DBOOST_TEST_FILESYSTEM -DBOOST_TEST_SYSTEM "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test" -lboost_filesystem -lboost_system
    CHECK_RESULT $? 0 0 "Failed to compile boost test program"
    "${TEST_TMP_DIR}/boost_test" filesystem | grep "BOOST_FS_EXISTS_OK"
    CHECK_RESULT $? 0 0 "Boost filesystem exists test failed"
    "${TEST_TMP_DIR}/boost_test" filesystem | grep "BOOST_FS_ISDIR_OK"
    CHECK_RESULT $? 0 0 "Boost filesystem is_directory test failed"
    "${TEST_TMP_DIR}/boost_test" filesystem | grep "BOOST_FS_TEMP_OK"
    CHECK_RESULT $? 0 0 "Boost filesystem temp_directory_path test failed"
    "${TEST_TMP_DIR}/boost_test" filesystem | grep "BOOST_FS_ABS_OK"
    CHECK_RESULT $? 0 0 "Boost filesystem absolute test failed"
    "${TEST_TMP_DIR}/boost_test" filesystem | grep "BOOST_FS_FILENAME_OK"
    CHECK_RESULT $? 0 0 "Boost filesystem filename test failed"
    "${TEST_TMP_DIR}/boost_test" system | grep "BOOST_SYS_ERRCODE_OK"
    CHECK_RESULT $? 0 0 "Boost system error_code test failed"
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

