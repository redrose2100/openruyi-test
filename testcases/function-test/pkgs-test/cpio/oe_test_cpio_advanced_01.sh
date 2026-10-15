#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   caowenqian
#@Contact       :   caowenqi@uniontech.com
#@Date          :   2026-02-02
#@License       :   Mulan PSL v2
#@Desc          :   command test-cpio advanced
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_advanced"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p "${TEST_DIR}"/testdir
    echo "test file 1" > "${TEST_DIR}"/testdir/file1
    echo "test file 2" > "${TEST_DIR}"/testdir/file2
    echo "test file 3" > "${TEST_DIR}"/testdir/file3
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -f option"
    cpio -o < "${TEST_DIR}"/filelist > "${TEST_DIR}"/cpio_all.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive..."
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    echo "testdir/file1" | cpio -ifdI cpio_all.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -f option..."
    test -d testdir
    CHECK_RESULT $? 0 0 "failed to create directory with -f option..."

    LOG_INFO "test cpio -E option"
    # 清理并创建测试目录
    rm -rf "${TEST_DIR}"/testdir
    mkdir -p "${TEST_DIR}"/testdir
    # 创建测试文件
    echo "test file 1" > "${TEST_DIR}"/testdir/file1
    echo "test file 2" > "${TEST_DIR}"/testdir/file2
    echo "test file 3" > "${TEST_DIR}"/testdir/file3
    #使用相对路径创建文件列表（关键修复）
    cd "${TEST_DIR}" || exit 1
    find testdir -type f > filelist_all
    # 创建cpio归档（使用相对路径的归档）
    cpio -o < filelist_all > cpio_pattern.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -E test..."
    # pattern_file中写相对路径（与归档中的路径一致）
    echo "testdir/file1" > pattern_file
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    # 使用-E选项提取指定文件
    cpio -idvE pattern_file < cpio_pattern.out 2>&1 | tee cpio_extract.log
    CHECK_RESULT $? 0 0 "failed to cpio extract with -E option..."

    # 验证文件是否正确提取
    test -f testdir/file1
    CHECK_RESULT $? 0 0 "failed to extract file1 with -E option..."
    # 验证其他文件没有被提取（应该只有file1被提取）
    test ! -f testdir/file2
    CHECK_RESULT $? 0 0 "unexpectedly extracted file2 with -E option..."
    test ! -f testdir/file3
    CHECK_RESULT $? 0 0 "unexpectedly extracted file3 with -E option..."

    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf "${TEST_DIR}"
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
