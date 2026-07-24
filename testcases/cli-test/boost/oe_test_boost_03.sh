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
# @Desc      :   Verify boost asio, date_time, string_algo, optional and variant functions
# ############################################
# shellcheck disable=SC2119

source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "boost-devel gcc-c++"
    TEST_TMP_DIR=$(mktemp -d /tmp/boost_test_XXXXXX) || { LOG_ERROR "mktemp failed"; exit 1; }
    export TEST_TMP_DIR
    cp -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)/common/boost_test.c" "${TEST_TMP_DIR}/boost_test.c"
    CHECK_RESULT $? 0 0 "Failed to copy boost test source file"
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    g++ -std=c++11 -DBOOST_TEST_ASIO "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_asio" -lboost_system
    CHECK_RESULT $? 0 0 "Failed to compile boost asio test"
    "${TEST_TMP_DIR}/boost_test_asio" asio | grep "BOOST_ASIO_TIMER_OK"
    CHECK_RESULT $? 0 0 "Boost asio timer test failed"
    "${TEST_TMP_DIR}/boost_test_asio" asio | grep "BOOST_ASIO_SOCKET_OK"
    CHECK_RESULT $? 0 0 "Boost asio socket test failed"
    g++ -std=c++11 -DBOOST_TEST_DATE_TIME "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_date_time" -lboost_date_time
    CHECK_RESULT $? 0 0 "Failed to compile boost date_time test"
    "${TEST_TMP_DIR}/boost_test_date_time" date_time | grep "BOOST_DATE_OK"
    CHECK_RESULT $? 0 0 "Boost date_time date test failed"
    "${TEST_TMP_DIR}/boost_test_date_time" date_time | grep "BOOST_TIME_NOW_OK"
    CHECK_RESULT $? 0 0 "Boost date_time time test failed"
    g++ -std=c++11 -DBOOST_TEST_STRING_ALGO "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_string_algo"
    CHECK_RESULT $? 0 0 "Failed to compile boost string_algo test"
    "${TEST_TMP_DIR}/boost_test_string_algo" string_algo | grep "BOOST_SA_TRIM_OK"
    CHECK_RESULT $? 0 0 "Boost string_algo trim test failed"
    "${TEST_TMP_DIR}/boost_test_string_algo" string_algo | grep "BOOST_SA_SPLIT_OK"
    CHECK_RESULT $? 0 0 "Boost string_algo split test failed"
    g++ -std=c++11 -DBOOST_TEST_OPTIONAL -DBOOST_TEST_VARIANT "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_other"
    CHECK_RESULT $? 0 0 "Failed to compile boost optional/variant test"
    "${TEST_TMP_DIR}/boost_test_other" optional | grep "BOOST_OPT_VALUE_OK"
    CHECK_RESULT $? 0 0 "Boost optional test failed"
    "${TEST_TMP_DIR}/boost_test_other" variant | grep "BOOST_VAR_VISITOR_OK"
    CHECK_RESULT $? 0 0 "Boost variant visitor test failed"
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

