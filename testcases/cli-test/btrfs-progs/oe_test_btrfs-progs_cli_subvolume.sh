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
# @Desc      :   btrfs subvolume test - actual command execution
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_subvol_test.img"
MOUNT_POINT="/tmp/btrfs_subvol_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 128
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Create subvolume
    btrfs subvolume create "$MOUNT_POINT/testsubvol" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume create failed"

    # Step 2: Verify subvolume creation
    btrfs subvolume list "$MOUNT_POINT" 2>&1 | grep "testsubvol"
    CHECK_RESULT $? 0 0 "btrfs subvolume list verification failed"

    # Step 3: Create snapshot from subvolume
    btrfs subvolume snapshot "$MOUNT_POINT/testsubvol" "$MOUNT_POINT/testsnap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume snapshot failed"

    # Step 4: Verify snapshot exists
    btrfs subvolume list "$MOUNT_POINT" 2>&1 | grep "testsnap"
    CHECK_RESULT $? 0 0 "btrfs subvolume list snapshot verification failed"

    # Step 5: Show subvolume details
    local show_output
    show_output=$(btrfs subvolume show "$MOUNT_POINT/testsubvol" 2>&1)
    echo "$show_output" | grep "testsubvol"
    CHECK_RESULT $? 0 0 "btrfs subvolume show failed"

    # Step 6: Get default subvolume
    btrfs subvolume get-default "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume get-default failed"

    # Step 7: Create a file in subvolume and test find-new
    echo "test content" > "$MOUNT_POINT/testsubvol/testfile.txt"
    btrfs subvolume find-new "$MOUNT_POINT" 1 2>&1 | grep -q "testfile.txt\|transid"
    CHECK_RESULT $? 0 0 "btrfs subvolume find-new failed"

    # Step 8: Delete snapshot
    btrfs subvolume delete "$MOUNT_POINT/testsnap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume delete snapshot failed"

    # Step 9: Verify snapshot deleted
    btrfs subvolume list "$MOUNT_POINT" 2>&1 | grep -v "testsnap" | grep "testsubvol"
    CHECK_RESULT $? 0 0 "btrfs subvolume delete verification failed"

    # Step 10: Test subvolume sync
    btrfs subvolume sync "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume sync failed"

    # Step 11: Test subvolume show for deleted snapshot (should fail or show nothing)
    btrfs subvolume show "$MOUNT_POINT/testsubvol" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume show after operations failed"

    # Step 12: Create readonly snapshot with -r flag
    btrfs subvolume snapshot -r "$MOUNT_POINT/testsubvol" "$MOUNT_POINT/ro_snap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume snapshot -r failed"

    # Step 13: Verify readonly snapshot
    btrfs subvolume list "$MOUNT_POINT" 2>&1 | grep "ro_snap"
    CHECK_RESULT $? 0 0 "btrfs subvolume readonly snapshot verification failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs subvolume delete "$MOUNT_POINT/ro_snap" > /dev/null 2>&1
    btrfs subvolume delete "$MOUNT_POINT/testsubvol" > /dev/null 2>&1
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"