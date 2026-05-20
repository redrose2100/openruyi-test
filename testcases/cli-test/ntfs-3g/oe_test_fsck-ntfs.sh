#!/usr/bin/bash
# Copyright (c) 2026.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2026-5-18
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.ntfs test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    TEST_DIR="/tmp/fsck_ntfs_test"
    IMG_FILE="${TEST_DIR}/ntfs_test.img"
    MOUNT_POINT="${TEST_DIR}/mnt"
    LOOP_DEV=""
    cur_lang=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "ntfs-3g parted util-linux"
    umount "${MOUNT_POINT}" &> /dev/null || true
    losetup -d "${LOOP_DEV}" &> /dev/null || true
    rm -rf "${TEST_DIR}"
    mkdir -p "${TEST_DIR}" "${MOUNT_POINT}"
    CHECK_RESULT $? 0 0 "Create test directory failed"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    dd if=/dev/zero of="${IMG_FILE}" bs=1M count=100 status=none
    CHECK_RESULT $? 0 0 "Create ntfs image file failed"

    parted -s "${IMG_FILE}" mklabel msdos
    CHECK_RESULT $? 0 0 "Create MBR label failed"
    parted -s "${IMG_FILE}" mkpart primary ntfs 0% 100%
    CHECK_RESULT $? 0 0 "Create primary ntfs partition failed"

    LOOP_DEV=$(losetup -fP --show "${IMG_FILE}")
    CHECK_RESULT $? 0 0 "Setup loop device failed"

    mkntfs -f -Q "${LOOP_DEV}p1"
    CHECK_RESULT $? 0 0 "Format to NTFS failed"

    mount -t ntfs-3g "${LOOP_DEV}p1" "${MOUNT_POINT}"
    CHECK_RESULT $? 0 0 "Mount NTFS partition failed"

    echo "fsck.ntfs test data" > "${MOUNT_POINT}/test.txt"
    CHECK_RESULT $? 0 0 "Write test file failed"

    umount "${MOUNT_POINT}"
    CHECK_RESULT $? 0 0 "Umount NTFS partition failed"

    fsck.ntfs "${LOOP_DEV}p1"
    CHECK_RESULT $? 0 2 "fsck.ntfs basic check failed" 

    fsck.ntfs -d -b "${LOOP_DEV}p1"
    CHECK_RESULT $? 0 1 "fsck.ntfs auto fix failed"

    mount -t ntfs-3g "${LOOP_DEV}p1" "${MOUNT_POINT}"
    CHECK_RESULT $? 0 0 "Remount NTFS failed"
    grep "fsck.ntfs test data" "${MOUNT_POINT}/test.txt"
    CHECK_RESULT $? 0 0 "NTFS filesystem verify failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE
    export LANG=$cur_lang
    umount -l "${MOUNT_POINT}" &> /dev/null || true
    if [ -n "${LOOP_DEV}" ] && losetup -a | grep -q "${LOOP_DEV}"; then
        losetup -d "${LOOP_DEV}" &> /dev/null || true
    fi
    rm -rf "${TEST_DIR}"
    LOG_INFO "Finish environment cleanup!"
}
