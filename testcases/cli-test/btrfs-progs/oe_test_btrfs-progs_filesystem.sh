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
# @Desc      :   btrfs filesystem operations test - create/mount/format
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables for test
LOOP_FILE="/tmp/btrfs_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_test_mount"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    # Install btrfs-progs
    DNF_INSTALL btrfs-progs

    # Check if running in container or virtual environment
    if [ -f /.dockerenv ] || [ -f /proc/1/cgroup ] && grep -q docker /proc/1/cgroup 2>/dev/null; then
        LOG_INFO "Running in container environment, skipping filesystem operations."
        exit 255
    fi

    # Check for root privileges
    if [ "$(id -u)" -ne 0 ]; then
        LOG_INFO "Not running as root, skipping filesystem operations."
        exit 255
    fi

    btrfs_setup_loopfile "$LOOP_FILE" 128

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Format the loopback device with btrfs
    mkfs.btrfs -f "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to format device with btrfs"

    # Step 2: Create mount point
    mkdir -p "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "Failed to create mount point"

    # Step 3: Mount the btrfs filesystem
    mount "$LOOP_DEV" "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to mount btrfs filesystem"

    # Step 4: Verify btrfs filesystem is mounted
    mount | grep "$MOUNT_POINT"
    CHECK_RESULT $? 0 0 "btrfs filesystem not mounted"

    # Step 5: Create a test file on btrfs filesystem
    echo "btrfs test file content" > "$MOUNT_POINT/testfile.txt"
    CHECK_RESULT $? 0 0 "Failed to create test file"

    # Step 6: Verify file content
    grep "btrfs test file content" "$MOUNT_POINT/testfile.txt"
    CHECK_RESULT $? 0 0 "File content verification failed"

    # Step 7: Test btrfs subvolume create
    btrfs subvolume create "$MOUNT_POINT/testsubvol"
    CHECK_RESULT $? 0 0 "Failed to create btrfs subvolume"

    # Step 8: Test btrfs subvolume list
    btrfs subvolume list "$MOUNT_POINT" | grep "testsubvol"
    CHECK_RESULT $? 0 0 "Failed to list btrfs subvolume"

    # Step 9: Test btrfs snapshot create
    btrfs subvolume snapshot "$MOUNT_POINT/testsubvol" "$MOUNT_POINT/testsnap"
    CHECK_RESULT $? 0 0 "Failed to create btrfs snapshot"

    # Step 10: Test btrfs filesystem usage
    btrfs filesystem df "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to get btrfs filesystem usage"

    # Step 11: Test btrfs filesystem show
    btrfs filesystem show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to show btrfs filesystem info"

    # Step 12: Test btrfs property get/set
    btrfs property set "$MOUNT_POINT" compression zlib
    CHECK_RESULT $? 0 0 "Failed to set btrfs property"

    # Step 13: Test btrfs balance start
    btrfs balance start -dusage=10 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to start btrfs balance"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"