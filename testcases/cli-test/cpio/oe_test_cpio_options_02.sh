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
#@Desc      	:   command test-cpio options -m and -a
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_options_02"

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

    LOG_INFO "test cpio -m option"
    touch_time=$(stat -c %Y "${TEST_DIR}"/testdir/file1)
    sleep 1
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist_mtime
    cpio -o < "${TEST_DIR}"/filelist_mtime > "${TEST_DIR}"/cpio_mtime.out
    CHECK_RESULT $? 0 0 "failed to cpio create archive for -m test..."
    rm -rf "${TEST_DIR}"/testdir
    mkdir -p "${TEST_DIR}"/testdir
    cd "${TEST_DIR}" || exit 1
    cpio -imd < cpio_mtime.out
    CHECK_RESULT $? 0 0 "failed to cpio extract with -m option..."
    new_touch_time=$(stat -c %Y testdir/file1)
    CHECK_RESULT $((touch_time == new_touch_time)) 1 0 "failed to preserve modification time with -m option..."

    LOG_INFO "test cpio -a option"
    find "${TEST_DIR}"/testdir -type f > "${TEST_DIR}"/filelist_atime
    access_time_before=$(stat -c %X "${TEST_DIR}"/testdir/file1)
    sleep 1
    cpio -oa < "${TEST_DIR}"/filelist_atime > "${TEST_DIR}"/cpio_atime.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -a option..."
    access_time_after=$(stat -c %X "${TEST_DIR}"/testdir/file1)
    CHECK_RESULT $((access_time_before == access_time_after)) 1 0 "failed to reset access time with -a option..."

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

