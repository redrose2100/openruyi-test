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
# @Desc      :   Verify libssh package installation and key files check
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/libssh/common/libssh_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libssh libssh-devel gcc"
    mkdir -p /tmp/libssh_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/libssh_test || exit 1

    # Verify the packages are installed
    rpm -qa | grep -E "^libssh-[0-9]"
    CHECK_RESULT $? 0 0 "libssh package is not installed"
    rpm -qa | grep -E "^libssh-devel-"
    CHECK_RESULT $? 0 0 "libssh-devel package is not installed"

    # Verify version matches rpm metadata
    pkg_version=$(rpm -q libssh --qf '%{VERSION}')
    pkg-config --modversion libssh | grep "${pkg_version}"
    CHECK_RESULT $? 0 0 "pkg-config version does not match rpm version"

    # Verify the library can be compiled and linked correctly
    libssh_compile "${OET_PATH}"/testcases/cli-test/libssh/common/linktest.c /tmp/libssh_test/linktest
    libssh_run /tmp/libssh_test/linktest /tmp/libssh_test/linktest_out.txt
    grep "libssh link ok" /tmp/libssh_test/linktest_out.txt
    CHECK_RESULT $? 0 0 "libssh linked program failed to run"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libssh_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
