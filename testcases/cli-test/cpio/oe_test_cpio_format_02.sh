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
#@Author    	:   caowenqian
#@Contact   	:   caowenqi@uniontech.com
#@Date      	:   2026-02-02
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-cpio format file io
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_format_01"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p "${TEST_DIR}"/testdir
    echo "test file 1" > "${TEST_DIR}"/testdir/file1
    echo "test file 2" > "${TEST_DIR}"/testdir/file2
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -F option"
    cpio -oF "${TEST_DIR}"/archive.cpio < "${TEST_DIR}"/filelist
    CHECK_RESULT $? 0 0 "failed to cpio create with -F option..."
    test -f "${TEST_DIR}"/archive.cpio
    CHECK_RESULT $? 0 0 "failed to create archive file with -F option..."
    cpio -tF "${TEST_DIR}"/archive.cpio | grep -E "testdir/(file1|file2)"
    CHECK_RESULT $? 0 0 "failed to list archive with -F option..."

    LOG_INFO "test cpio -O option"
    cpio -oO "${TEST_DIR}"/output.cpio < "${TEST_DIR}"/filelist
    CHECK_RESULT $? 0 0 "failed to cpio create with -O option..."
    test -f "${TEST_DIR}"/output.cpio
    CHECK_RESULT $? 0 0 "failed to create archive file with -O option..."
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -id < output.cpio
    CHECK_RESULT $? 0 0 "failed to extract archive created with -O option..."
    test -f testdir/file1 && test -f testdir/file2
    CHECK_RESULT $? 0 0 "failed to verify extracted files from -O archive..."

    LOG_INFO "test cpio -I option with file"
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist2
    cpio -o < "${TEST_DIR}"/filelist2 > "${TEST_DIR}"/archive2.cpio
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -I test..."
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -idI archive2.cpio
    CHECK_RESULT $? 0 0 "failed to cpio extract with -I option..."
    test -f testdir/file1 && test -f testdir/file2
    CHECK_RESULT $? 0 0 "failed to verify extracted files with -I option..."

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
