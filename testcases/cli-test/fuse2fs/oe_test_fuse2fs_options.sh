#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026-04-23
# @License   :   Mulan PSL v2
# @Desc      :   test fuse2fs file operations
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "e2fsprogs"
    TEST_DIR="/tmp/fuse2fs_test_opts"
    MNT_DIR="/tmp/fuse2fs_mnt_opts"
    mkdir -p "${TEST_DIR}" "${MNT_DIR}"
    cd "${TEST_DIR}" || return
    dd if=/dev/zero of=test.img bs=1M count=100 2>/dev/null
    mkfs.ext4 -F test.img >/dev/null 2>&1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Test basic read-write mount
    LOG_INFO "Step 1: Read-write mount test"
    fuse2fs "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fuse2fs read-write mount failed"
    echo "test_content" > "${MNT_DIR}/test.txt"
    CHECK_RESULT $? 0 0 "write operation failed"
    grep -q "test_content" "${MNT_DIR}/test.txt"
    CHECK_RESULT $? 0 0 "read operation failed"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # Step 2: Test read-only mount
    LOG_INFO "Step 2: Read-only mount test"
    fuse2fs -o ro "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fuse2fs read-only mount failed"
    touch "${MNT_DIR}/test2.txt" 2>/dev/null
    CHECK_RESULT $? 0 1 "read-only mount should not allow write"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # Step 3: Test file and directory operations
    LOG_INFO "Step 3: File and directory operations test"
    fuse2fs "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fuse2fs mount failed"

    mkdir -p "${MNT_DIR}/testdir"
    CHECK_RESULT $? 0 0 "create directory failed"

    echo "file content" > "${MNT_DIR}/testdir/file.txt"
    CHECK_RESULT $? 0 0 "create file in subdir failed"

    ls "${MNT_DIR}/testdir/file.txt"
    CHECK_RESULT $? 0 0 "list file failed"

    rm -f "${MNT_DIR}/testdir/file.txt"
    CHECK_RESULT $? 0 0 "remove file failed"

    rmdir "${MNT_DIR}/testdir"
    CHECK_RESULT $? 0 0 "remove directory failed"

    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # Step 4: Test filesystem integrity check
    LOG_INFO "Step 4: Filesystem integrity check"
    fsck.ext4 -n "${TEST_DIR}/test.img" >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "filesystem integrity check failed"

    # Step 5: Test dumpe2fs metadata check
    LOG_INFO "Step 5: dumpe2fs metadata check"
    dumpe2fs -h "${TEST_DIR}/test.img" 2>/dev/null | grep -q "Block count"
    CHECK_RESULT $? 0 0 "dumpe2fs metadata check failed"

    # Step 6: Test fakeroot option
    LOG_INFO "Step 6: fakeroot option test"
    fuse2fs -o fakeroot "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fakeroot mount failed"
    find "${MNT_DIR}" -maxdepth 1 -exec ls -la {} \; 2>/dev/null | grep -q "root root"
    CHECK_RESULT $? 0 0 "fakeroot permission check failed"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # Step 7: Test help information
    LOG_INFO "Step 7: Help information test"
    fuse2fs -h 2>&1 | grep -qi "usage: fuse2fs"
    CHECK_RESULT $? 0 0 "help information missing"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    fusermount -u "${MNT_DIR}" 2>/dev/null
    rm -rf "${TEST_DIR}" "${MNT_DIR}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
