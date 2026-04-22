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
# @Author    :   gaoshuaishuai
# @Contact   :   gaoshuaishuai@uniontech.com
# @Date      :   2026/04/09
# @License   :   Mulan PSL v2
# @Desc      :   test fuse2fs
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "e2fsprogs"
    # 创建测试目录
    TEST_DIR="/tmp/fuse2fs_test"
    MNT_DIR="/tmp/fuse2fs_mnt"
    mkdir -p "${TEST_DIR}" "${MNT_DIR}"
    cd "${TEST_DIR}" || return
    # 创建测试镜像文件
    dd if=/dev/zero of=test.img bs=1M count=100 2>/dev/null
    mkfs.ext4 -F test.img >/dev/null 2>&1
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."

    # 步骤1：测试读写挂载
    LOG_INFO "Step 1: Read-write mount test"
    fuse2fs "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fuse2fs read-write mount failed"
    echo "test_content" > "${MNT_DIR}/test.txt"
    CHECK_RESULT $? 0 0 "write operation failed"
    grep -q "test_content" "${MNT_DIR}/test.txt"
    CHECK_RESULT $? 0 0 "read operation failed"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # 步骤2：测试只读挂载
    LOG_INFO "Step 2: Read-only mount test"
    fuse2fs -o ro "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fuse2fs read-only mount failed"
    touch "${MNT_DIR}/test2.txt" 2>/dev/null
    CHECK_RESULT $? 0 1 "read-only mount should not allow write"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # 步骤3：测试fakeroot选项（修复 SC2038：使用 -exec 替代 xargs）
    LOG_INFO "Step 3: fakeroot option test"
    fuse2fs -o fakeroot "${TEST_DIR}/test.img" "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fakeroot mount failed"
    # 使用 find -exec 替代 xargs，避免 SC2038
    find "${MNT_DIR}" -maxdepth 1 -exec ls -la {} \; 2>/dev/null | grep -q "root root"
    CHECK_RESULT $? 0 0 "fakeroot permission check failed"
    fusermount -u "${MNT_DIR}"
    CHECK_RESULT $? 0 0 "fusermount unmount failed"

    # 步骤4：测试帮助信息
    LOG_INFO "Step 4: Help information test"
    fuse2fs -h 2>&1 | grep -qi "usage: fuse2fs"
    CHECK_RESULT $? 0 0 "help information missing"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    fusermount -u "${MNT_DIR}" 2>/dev/null
    rm -rf "${TEST_DIR}" "${MNT_DIR}"
    # shellcheck disable=SC2119
    DNF_REMOVE "e2fsprogs"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

