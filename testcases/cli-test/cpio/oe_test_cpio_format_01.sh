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
#@Desc      	:   command test-cpio format
#####################################


source "${OET_PATH}"/libs/locallibs/common_lib.sh

TEST_DIR="/tmp/oe_test_cpio_format"

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

    LOG_INFO "test cpio -c option"
    cpio -oc < "${TEST_DIR}"/filelist > "${TEST_DIR}"/cpio_newc.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -c option..."
    file "${TEST_DIR}"/cpio_newc.out | grep -i "cpio"
    CHECK_RESULT $? 0 0 "failed to create newc format archive with -c option..."

    LOG_INFO "test cpio -H option"
    cpio -oH newc < "${TEST_DIR}"/filelist > "${TEST_DIR}"/cpio_format_newc.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -H newc option..."
    cpio -oH odc < "${TEST_DIR}"/filelist > "${TEST_DIR}"/cpio_format_odc.out
    CHECK_RESULT $? 0 0 "failed to cpio create with -H odc option..."
    test -f "${TEST_DIR}"/cpio_format_newc.out && test -f "${TEST_DIR}"/cpio_format_odc.out
    CHECK_RESULT $? 0 0 "failed to create archives with different formats..."

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
