#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-30
# @License   :   Mulan PSL v2
# @Desc      :   btrfs check/restore/rescue test (offline operations)
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_ins03_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_ins03_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256
    btrfs_create_test_data "$MOUNT_POINT" 10

    # Create subvolume for offline tests
    btrfs subvolume create "$MOUNT_POINT/testvol" > /dev/null 2>&1
    dd if=/dev/zero of="$MOUNT_POINT/testvol/data.bin" bs=1M count=5 > /dev/null 2>&1

    # Sync and prepare for offline tests
    btrfs filesystem sync "$MOUNT_POINT" > /dev/null 2>&1
    umount "$MOUNT_POINT" > /dev/null 2>&1

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== Check tests (offline) =====
    # Step 1: Test btrfs check on unmounted device
    btrfs check "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs check device failed"

    # Step 2: Test btrfs check with --force option
    btrfs check --force "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs check --force failed"

    # Step 3: Test btrfs check output verification
    btrfs check "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs check output verification failed"

    # ===== Restore tests (offline) =====
    # Step 4: Test btrfs restore to extract files
    local restore_dir="/tmp/btrfs_restore_test01"
    rm -rf "$restore_dir" 2>/dev/null
    mkdir -p "$restore_dir"
    btrfs restore "$LOOP_DEV" "$restore_dir" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs restore failed"

    # Step 5: Verify restore output
    ls -la "$restore_dir" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs restore output verification failed"

    # Step 6: Test btrfs restore with --help
    btrfs restore --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs restore help failed"

    # Step 7: Cleanup restore dirs
    rm -rf "$restore_dir"

    # ===== Rescue tests (offline) =====
    # Step 8: Test btrfs rescue --help
    btrfs rescue --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs rescue help failed"

    # Step 9: Test btrfs rescue zero-log help
    btrfs rescue zero-log --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs rescue zero-log help failed"

    # ===== Remount after offline tests =====
    # Step 11: Remount filesystem
    mount "$LOOP_DEV" "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "remount failed"

    # Step 12: Verify filesystem accessible after remount
    btrfs filesystem show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem show after remount failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
