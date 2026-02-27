#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Desc      	:   command test-cpio options -v and -d
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_options_01"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cpio

    mkdir -p "${TEST_DIR}"/testdir/subdir
    echo "test file 1" > "${TEST_DIR}"/testdir/file1
    echo "test file 2" > "${TEST_DIR}"/testdir/file2
    echo "test file 3" > "${TEST_DIR}"/testdir/subdir/file3
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist

    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    LOG_INFO "test cpio -v option"
    cpio -ov < "${TEST_DIR}"/filelist > "${TEST_DIR}"/cpio_verbose.out 2>"${TEST_DIR}"/cpio_verbose.log
    CHECK_RESULT $? 0 0 "failed to cpio create with -v option..."
    grep -E "testdir/(file1|file2|subdir/file3)" "${TEST_DIR}"/cpio_verbose.log
    CHECK_RESULT $? 0 0 "failed to display verbose output with -v option..."

    LOG_INFO "test cpio -d option"
    rm -rf "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -id < cpio_verbose.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -d option..."
    test -d testdir/subdir
    CHECK_RESULT $? 0 0 "failed to create directory with -d option..."

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
