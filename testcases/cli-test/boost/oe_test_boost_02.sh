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
# @Desc      :   Verify boost regex, thread and smart_ptr sublibrary functions
# ############################################

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
    g++ -std=c++11 -DBOOST_TEST_REGEX "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_regex" -lboost_regex
    CHECK_RESULT $? 0 0 "Failed to compile boost regex test"
    "${TEST_TMP_DIR}/boost_test_regex" regex | grep "BOOST_REGEX_SEARCH_OK"
    CHECK_RESULT $? 0 0 "Boost regex search test failed"
    "${TEST_TMP_DIR}/boost_test_regex" regex | grep "BOOST_REGEX_REPLACE_OK"
    CHECK_RESULT $? 0 0 "Boost regex replace test failed"
    "${TEST_TMP_DIR}/boost_test_regex" regex | grep "BOOST_REGEX_MATCH_OK"
    CHECK_RESULT $? 0 0 "Boost regex match test failed"
    g++ -std=c++11 -DBOOST_TEST_THREAD "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_thread" -lboost_thread -lboost_system -lboost_chrono -lpthread
    CHECK_RESULT $? 0 0 "Failed to compile boost thread test"
    "${TEST_TMP_DIR}/boost_test_thread" thread | grep "BOOST_THREAD_SYNC_OK"
    CHECK_RESULT $? 0 0 "Boost thread sync test failed"
    "${TEST_TMP_DIR}/boost_test_thread" thread | grep "BOOST_THREAD_ID_OK"
    CHECK_RESULT $? 0 0 "Boost thread id test failed"
    "${TEST_TMP_DIR}/boost_test_thread" thread | grep "BOOST_THREAD_SLEEP_OK"
    CHECK_RESULT $? 0 0 "Boost thread sleep test failed"
    g++ -std=c++11 -DBOOST_TEST_SMART_PTR "${TEST_TMP_DIR}/boost_test.c" -o "${TEST_TMP_DIR}/boost_test_smart_ptr"
    CHECK_RESULT $? 0 0 "Failed to compile boost smart_ptr test"
    "${TEST_TMP_DIR}/boost_test_smart_ptr" smart_ptr | grep "BOOST_SP_OK"
    CHECK_RESULT $? 0 0 "Boost shared_ptr test failed"
    "${TEST_TMP_DIR}/boost_test_smart_ptr" smart_ptr | grep "BOOST_UP_OK"
    CHECK_RESULT $? 0 0 "Boost unique_ptr test failed"
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

