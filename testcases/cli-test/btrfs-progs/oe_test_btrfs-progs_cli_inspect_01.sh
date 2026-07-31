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
# @Desc      :   btrfs inspect-internal test
# ############################################
# shellcheck disable=SC1090,SC1091,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_ins01_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_ins01_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256

    # Create test data for inspect tests
    dd if=/dev/zero of="$MOUNT_POINT/testfile.bin" bs=1M count=10 > /dev/null 2>&1
    echo "test content" > "$MOUNT_POINT/testfile.txt"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== inspect-internal tests =====
    # Step 1: Get rootid of mount point
    local rootid_output
    rootid_output=$(btrfs inspect-internal rootid "$MOUNT_POINT" 2>&1)
    echo "$rootid_output" | grep -Eq "^[0-9]+$"
    CHECK_RESULT $? 0 0 "btrfs inspect-internal rootid failed"

    # Step 2: Get min device size
    btrfs inspect-internal min-dev-size "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal min-dev-size failed"

    # Step 3: Get min device size output verification
    local min_size_output
    min_size_output=$(btrfs inspect-internal min-dev-size "$MOUNT_POINT" 2>&1)
    echo "$min_size_output" | grep -q "bytes"
    CHECK_RESULT $? 0 0 "btrfs inspect-internal min-dev-size output verification failed"

    # Step 4: Get inode-resolve for a file (using mount point)
    local inode
    inode=$(stat -c %i "$MOUNT_POINT/testfile.bin")
    btrfs inspect-internal inode-resolve "$inode" "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal inode-resolve failed"

    # Step 5: Get inode-resolve output verification
    local inode_output
    inode_output=$(btrfs inspect-internal inode-resolve "$inode" "$MOUNT_POINT" 2>&1)
    echo "$inode_output" | grep -q "testfile.bin"
    CHECK_RESULT $? 0 0 "btrfs inspect-internal inode-resolve output verification failed"

    # Step 6: Get subvolid-resolve for subvolume
    btrfs inspect-internal subvolid-resolve 5 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal subvolid-resolve failed"

    # Step 7: Dump superblock from device
    btrfs inspect-internal dump-super "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-super failed"

    # Step 8: Dump superblock output verification
    local super_output
    super_output=$(btrfs inspect-internal dump-super "$LOOP_DEV" 2>&1)
    echo "$super_output" | grep -q "magic"
    CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-super output verification failed"

    # Step 9: Dump tree stats
    btrfs inspect-internal tree-stats "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal tree-stats failed"

    # Step 10: Get inspect-internal logical-resolve help
    btrfs inspect-internal logical-resolve --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal logical-resolve help failed"

    # Step 11: Get inspect-internal dump-tree help
    btrfs inspect-internal dump-tree --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs inspect-internal dump-tree help failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
