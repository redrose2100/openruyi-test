#!/usr/bin/bash
# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
# `http://license.coscl.org.cn/MulanPSL2`
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# ##############################################
# @Author    :   wangkun
# @Contact   :   wkun1005@163.com
# @Date      :   2026-07-15
# @License   :   Mulan PSL v2
# @Desc      :   libverto asynchronous event loop library
# ##############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libverto libverto-devel libverto-libev libverto-libevent libevent libevent-devel gcc gcc-c++"
    TEST_TMP_DIR=$(mktemp -d /tmp/libverto_test_XXXXXX)
    export TEST_TMP_DIR
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    rpm -q libverto > /dev/null
    CHECK_RESULT $? 0 0 "libverto package not installed"
    rpm -V libverto
    CHECK_RESULT $? 0 0 "libverto package verification failed"
    test -f /usr/include/verto.h
    CHECK_RESULT $? 0 0 "libverto header file verto.h missing"
    rpm -ql libverto | grep -E "\.(so|so\.[0-9]+)$"
    CHECK_RESULT $? 0 0 "libverto shared library missing"
    cp -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1; pwd)/common/libverto_test.c" "${TEST_TMP_DIR}/libverto_test.c"
    CHECK_RESULT $? 0 0 "Failed to copy libverto test source file"
    gcc -o "${TEST_TMP_DIR}/libverto_test" "${TEST_TMP_DIR}/libverto_test.c" -lverto
    CHECK_RESULT $? 0 0 "Failed to compile libverto test program"
    "${TEST_TMP_DIR}/libverto_test" > "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "Failed to run libverto default backend test"
    grep "VERTO_DEFAULT_BACKEND_SELECTED" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto default backend selection failed"
    grep "VERTO_TIMER_OK" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto timer event test failed"
    grep "VERTO_FD_EVENT_OK" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto FD event test failed"
    grep "VERTO_DEFAULT_ALL_PASS" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto default backend all tests failed"
    "${TEST_TMP_DIR}/libverto_test" libev >> "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "Failed to run libverto libev backend test"
    grep "VERTO_LIBEV_BACKEND_SELECTED" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto libev backend selection failed"
    grep "VERTO_LIBEV_ALL_PASS" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto libev backend all tests failed"
    "${TEST_TMP_DIR}/libverto_test" libevent >> "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "Failed to run libverto libevent backend test"
    grep "VERTO_LIBEVENT_BACKEND_SELECTED" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto libevent backend selection failed"
    grep "VERTO_LIBEVENT_ALL_PASS" "${TEST_TMP_DIR}/libverto_test_out.txt"
    CHECK_RESULT $? 0 0 "libverto libevent backend all tests failed"
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
