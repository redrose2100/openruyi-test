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
# @Date      :   2026/07/09
# @License   :   Mulan PSL v2
# @Desc      :   Verify libev package installation and key files check
# #############################################
# shellcheck disable=SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/function-test/pkgs-test/libev/common/libev_common.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libev libev-devel gcc"
    mkdir -p /tmp/libev_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd /tmp/libev_test || exit 1

    # Verify the packages are installed
    rpm -qa | grep -E "^libev-[0-9]"
    CHECK_RESULT $? 0 0 "libev package is not installed"
    rpm -qa | grep -E "^libev-devel-"
    CHECK_RESULT $? 0 0 "libev-devel package is not installed"

    # Check header files exist
    test -f /usr/include/ev.h
    CHECK_RESULT $? 0 0 "ev.h header file does not exist"
    test -f /usr/include/ev++.h
    CHECK_RESULT $? 0 0 "ev++.h header file does not exist"

    # Check shared library files exist
    test -f /usr/lib64/libev.so
    CHECK_RESULT $? 0 0 "libev.so development symlink does not exist"
    # Runtime library SONAME is queried via rpm to avoid hardcoding version
    rpm -ql libev | grep -E "libev\.so\.[0-9]+" | grep -v "libev\.so$"
    CHECK_RESULT $? 0 0 "libev runtime library does not exist"

    # Check rpm query lists the expected key files
    rpm -ql libev-devel | grep -E "ev\.h$"
    CHECK_RESULT $? 0 0 "rpm query does not list ev.h in libev-devel"
    rpm -ql libev | grep -E "libev\.so"
    CHECK_RESULT $? 0 0 "rpm query does not list libev.so in libev"

    # Verify the library can be compiled and linked correctly
    libev_compile "${OET_PATH}"/testcases/function-test/pkgs-test/libev/common/linktest.c /tmp/libev_test/linktest
    libev_run /tmp/libev_test/linktest /tmp/libev_test/linktest_out.txt
    grep "libev link ok" /tmp/libev_test/linktest_out.txt
    CHECK_RESULT $? 0 0 "libev linked program failed to run"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/libev_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
