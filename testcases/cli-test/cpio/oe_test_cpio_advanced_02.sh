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
#@Date      	:   2026-06-10
#@License   	:   Mulan PSL v2
#@Desc      	:   command test-cpio advanced file attributes
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_advanced_01"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p "${TEST_DIR}"/testdir
    echo "test file" > "${TEST_DIR}"/testdir/testfile
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist_owner

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -R option"
    cpio -o < "${TEST_DIR}"/filelist_owner > "${TEST_DIR}"/cpio_owner.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -R test..."
    test_user=$(id -un)
    test_group=$(id -gn)
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -idR "${test_user}:${test_group}" < cpio_owner.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -R option..."
    file_owner=$(stat -c "%U:%G" testdir/testfile)
    CHECK_RESULT $([ "$file_owner" = "${test_user}:${test_group}" ] && echo 0 || echo 1) 0 0 "failed to set file ownership with -R option..."

    LOG_INFO "test cpio -l option"
    rm -rf "${TEST_DIR}"/testdir "${TEST_DIR}"/testdir_link
    mkdir -p "${TEST_DIR}"/testdir "${TEST_DIR}"/testdir_link
    echo "test file" > "${TEST_DIR}"/testdir/testfile
    cd "${TEST_DIR}"/testdir || exit 1
    find . -type f > "${TEST_DIR}"/filelist_link
    cpio -pl "${TEST_DIR}"/testdir_link < "${TEST_DIR}"/filelist_link
    CHECK_RESULT $? 0 0 "failed to cpio pass-through with -l option..."
    cd "${TEST_DIR}" || exit 1
    test -f testdir_link/testfile
    CHECK_RESULT $? 0 0 "failed to link file with -l option..."
    inode1=$(stat -c %i testdir/testfile)
    inode2=$(stat -c %i testdir_link/testfile)
    CHECK_RESULT $((inode1 == inode2)) 1 0 "failed to create hard link with -l option..."

    LOG_INFO "test cpio --sparse option"
    rm -rf "${TEST_DIR}"/testdir
    mkdir -p "${TEST_DIR}"/testdir
    dd if=/dev/zero of="${TEST_DIR}"/testdir/sparse_file bs=1M count=0 seek=10 2>/dev/null
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist_sparse
    cpio -o < "${TEST_DIR}"/filelist_sparse > "${TEST_DIR}"/cpio_sparse.out
    CHECK_RESULT $? 0 0 "failed to cpio create with sparse file..."
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -id --sparse < cpio_sparse.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with --sparse option..."
    test -f testdir/sparse_file
    CHECK_RESULT $? 0 0 "failed to extract sparse file with --sparse option..."

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
