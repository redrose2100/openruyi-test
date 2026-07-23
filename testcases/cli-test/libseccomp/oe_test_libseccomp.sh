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
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-23
# @License   :   Mulan PSL v2
# @Desc      :   libseccomp package installation and filtering functionality test
# ############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_FILE="test_seccomp.c"
TEST_BIN="test_seccomp"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libseccomp libseccomp-devel gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # 包安装完整性验证
    rpm -q libseccomp
    CHECK_RESULT $? 0 0 "libseccomp package not installed"

    rpm -q libseccomp-devel
    CHECK_RESULT $? 0 0 "libseccomp-devel package not installed"

    # 动态检测库路径（兼容 x86_64 和 aarch64）
    LIBDIR=$(pkg-config --variable=libdir libseccomp 2>/dev/null)
    [ -z "$LIBDIR" ] && LIBDIR="/usr/lib64"

    [ -f "${LIBDIR}/libseccomp.so" ]
    CHECK_RESULT $? 0 0 "libseccomp.so not found in ${LIBDIR}"

    [ -f "${LIBDIR}/libseccomp.so.2" ]
    CHECK_RESULT $? 0 0 "libseccomp.so.2 not found in ${LIBDIR}"

    # 验证库是符号链接
    [ -L "${LIBDIR}/libseccomp.so" ]
    CHECK_RESULT $? 0 0 "libseccomp.so is not a symlink"

    [ -f "/usr/include/seccomp.h" ]
    CHECK_RESULT $? 0 0 "seccomp.h not found"

    # 验证 pkg-config
    pkg-config --exists libseccomp
    CHECK_RESULT $? 0 0 "libseccomp pkg-config not found"

    pkg-config --modversion libseccomp | grep -qE "^[0-9]+\.[0-9]+"
    CHECK_RESULT $? 0 0 "libseccomp version format invalid"

    # 验证 RPM 元信息
    rpm -qi libseccomp | grep -q "syscall filtering"
    CHECK_RESULT $? 0 0 "libseccomp RPM description incorrect"

    #  编译并运行过滤器功能测试
    gcc -o "$TEST_BIN" "$TEST_FILE" -lseccomp -Wall -Wextra
    CHECK_RESULT $? 0 0 "Compile test file failed"

    ./$TEST_BIN
    CHECK_RESULT $? 0 0 "Seccomp filter tests failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$TEST_BIN" *.o
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
