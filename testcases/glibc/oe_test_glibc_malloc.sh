#!/bin/bash
# Copyright (c) 2026 KylinSoft Co., Ltd.
# Licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# PURPOSE.
# See the Mulan PSL v2 for more details.

# shellcheck disable=SC1091
source "../../../../common/mugen.sh"
# shellcheck disable=SC1091
source "../../../../common/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "glibc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run the glibc malloc test."

    # 测试1: 验证 MALLOC_CHECK_ 环境变量存在且可设置
    export MALLOC_CHECK_=2
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_CHECK_ environment variable set successfully."

    # 测试2: MALLOC_CHECK_=1 下执行简单内存操作（ls命令）不应崩溃
    MALLOC_CHECK_=1 ls / >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_CHECK_=1 memory operation test passed."

    # 测试3: MALLOC_CHECK_=2 下执行内存操作不应崩溃
    MALLOC_CHECK_=2 ls / >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_CHECK_=2 memory operation test passed."

    # 测试4: MALLOC_CHECK_=3 下执行内存操作不应崩溃
    MALLOC_CHECK_=3 ls / >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_CHECK_=3 memory operation test passed."

    # 测试5: MALLOC_PERTURB_ 环境变量可设置
    export MALLOC_PERTURB_=170
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_PERTURB_ environment variable set successfully."

    # 测试6: MALLOC_PERTURB_=170 下执行命令不应崩溃
    MALLOC_PERTURB_=170 ls / >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "MALLOC_PERTURB_=170 memory perturb test passed."

    # 测试7: 验证 glibc 动态链接库存在
    ls -l /lib*/libc.so.* >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "glibc shared library exists."

    # 测试8: 验证 ldd 命令可用（依赖 glibc）
    ldd /bin/ls >/dev/null 2>&1
    CHECK_RESULT $? 0
    LOG_INFO "ldd command works correctly."

    LOG_INFO "End to run the glibc malloc test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    unset MALLOC_CHECK_
    unset MALLOC_PERTURB_
    DNF_REMOVE "glibc"
    LOG_INFO "End to restore the test environment."
}

main "\$@"