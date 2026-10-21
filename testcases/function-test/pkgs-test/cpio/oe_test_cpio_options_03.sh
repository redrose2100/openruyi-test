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
#@Date      	:   2026-03-10
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-cpio options -L and -n
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_options_03"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p "${TEST_DIR}"/testdir/subdir
    echo "test file 1" > "${TEST_DIR}"/testdir/file1
    echo "test file 2" > "${TEST_DIR}"/testdir/file2
    echo "test file 3" > "${TEST_DIR}"/testdir/subdir/file3

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -L option"
    ln -sf file1 "${TEST_DIR}"/testdir/symlink1
    find "${TEST_DIR}"/testdir -type f -o -type l > "${TEST_DIR}"/filelist_symlink
    cpio -oL < "${TEST_DIR}"/filelist_symlink > "${TEST_DIR}"/cpio_deref.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -L option..."
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -id < cpio_deref.out
    CHECK_RESULT $? 0 0 "failed to cpio extract after -L option..."
    test -f testdir/symlink1 && ! test -L testdir/symlink1
    CHECK_RESULT $? 0 0 "failed to dereference symlink with -L option..."

    LOG_INFO "test cpio -n option"
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist_n
    cpio -o < "${TEST_DIR}"/filelist_n > "${TEST_DIR}"/cpio_numeric.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -n test..."
    cpio -t < "${TEST_DIR}"/cpio_numeric.out > "${TEST_DIR}"/filelist_numeric
    CHECK_RESULT $? 0 0 "failed to cpio list archive..."
    cpio -tn < "${TEST_DIR}"/cpio_numeric.out > "${TEST_DIR}"/filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to cpio list with -n option..."
    test -s "${TEST_DIR}"/filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to generate output with -n option..."
    grep -q "[0-9]" "${TEST_DIR}"/filelist_numeric_uid
    CHECK_RESULT $? 0 0 "failed to display numeric UID/GID with -n option..."

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
