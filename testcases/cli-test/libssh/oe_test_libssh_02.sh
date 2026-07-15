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
# @Date      :   2026/07/13
# @License   :   Mulan PSL v2
# @Desc      :   Test libssh core API functionality (session, key)
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/libssh/common/libssh_common.sh

LIBSSH_COMMON="${OET_PATH}"/testcases/cli-test/libssh/common

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libssh libssh-devel gcc"
    mkdir -p /tmp/libssh_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/libssh_test || exit 1

    # Test ssh_new / ssh_options_set / ssh_free lifecycle
    libssh_compile "${LIBSSH_COMMON}"/session_test.c /tmp/libssh_test/session_test
    libssh_run /tmp/libssh_test/session_test /tmp/libssh_test/session_out.txt
    grep "session created ok" /tmp/libssh_test/session_out.txt
    CHECK_RESULT $? 0 0 "ssh_new failed to create session"
    grep "session options set ok" /tmp/libssh_test/session_out.txt
    CHECK_RESULT $? 0 0 "ssh_options_set failed to set host/port/user"
    grep "session freed ok" /tmp/libssh_test/session_out.txt
    CHECK_RESULT $? 0 0 "ssh_free failed to release session"

    # Test ssh_pki_generate / ssh_key_type / ssh_key_free
    libssh_compile "${LIBSSH_COMMON}"/key_test.c /tmp/libssh_test/key_test
    libssh_run /tmp/libssh_test/key_test /tmp/libssh_test/key_out.txt
    grep "key generated ok" /tmp/libssh_test/key_out.txt
    CHECK_RESULT $? 0 0 "ssh_pki_generate failed to generate ED25519 key"
    grep "key type ok" /tmp/libssh_test/key_out.txt
    CHECK_RESULT $? 0 0 "ssh_key_type returned unexpected key type"
    grep "key freed ok" /tmp/libssh_test/key_out.txt
    CHECK_RESULT $? 0 0 "ssh_key_free failed to release key"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libssh_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"

