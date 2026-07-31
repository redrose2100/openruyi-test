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
# @Desc      :   btrfs send/receive test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
SRC_LOOP_FILE="/tmp/btrfs_send01_src.img"
SRC_LOOP_DEV=""
SRC_MOUNT="/tmp/btrfs_send01_src_mnt"
DST_LOOP_FILE="/tmp/btrfs_send01_dst.img"
DST_LOOP_DEV=""
DST_MOUNT="/tmp/btrfs_send01_dst_mnt"
SNAP_FILE="/tmp/btrfs_snap01.send"
SNAP_FILE2="/tmp/btrfs_snap02.send"
DST_LOOP2_FILE="/tmp/btrfs_dst02_test.img"
DST_MOUNT2="/tmp/btrfs_send01_dst2_mnt"
DST_DEV2=""
NODATA_FILE="/tmp/btrfs_snap_nodata01.send"
CLONE_FILE="/tmp/btrfs_snap_clone01.send"
QUIET_FILE="/tmp/btrfs_snap_quiet01.send"
DUMP_FILE="/tmp/btrfs_snap_dump01.send"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs

    # Setup source filesystem
    btrfs_setup_loopdev "$SRC_LOOP_FILE" "$SRC_MOUNT" 256
    SRC_LOOP_DEV="$LOOP_DEV"

    # Create subvolume with test data
    btrfs subvolume create "$SRC_MOUNT/send_vol" > /dev/null 2>&1
    dd if=/dev/zero of="$SRC_MOUNT/send_vol/data.bin" bs=1M count=10 > /dev/null 2>&1
    echo "test file content" > "$SRC_MOUNT/send_vol/testfile.txt"

    # Create snapshot for send test
    btrfs subvolume snapshot -r "$SRC_MOUNT/send_vol" "$SRC_MOUNT/send_snap" > /dev/null 2>&1

    # Make changes and create second snapshot
    echo "additional content" > "$SRC_MOUNT/send_vol/testfile2.txt"
    btrfs subvolume snapshot -r "$SRC_MOUNT/send_vol" "$SRC_MOUNT/send_snap2" > /dev/null 2>&1

    # Setup destination filesystem
    btrfs_setup_loopdev "$DST_LOOP_FILE" "$DST_MOUNT" 256
    DST_LOOP_DEV="$LOOP_DEV"

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== btrfs send tests =====
    # Step 1: Test btrfs send - basic snapshot send to file
    btrfs send -f "$SNAP_FILE" "$SRC_MOUNT/send_snap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send -f snapshot to file failed"

    # Step 2: Verify send file exists
    ls -la "$SNAP_FILE" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send file not created"

    # Step 3: Test btrfs send with --no-data option
    btrfs send --no-data -f "$NODATA_FILE" "$SRC_MOUNT/send_snap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send --no-data failed"

    # Step 4: Test btrfs send with -p parent option (incremental)
    btrfs send -p "$SRC_MOUNT/send_snap" -f "$SNAP_FILE2" "$SRC_MOUNT/send_snap2" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send -p parent incremental failed"

    # Step 5: Test btrfs send with -c clone option
    btrfs send -c "$SRC_MOUNT/send_snap" -f "$CLONE_FILE" "$SRC_MOUNT/send_snap2" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send -c clone failed"

    # Step 6: Test btrfs send with -q quiet option
    btrfs send -q -f "$QUIET_FILE" "$SRC_MOUNT/send_snap" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs send -q quiet failed"

    # ===== btrfs receive tests =====
    # Step 7: Test btrfs receive with --dump option
    btrfs send -f "$DUMP_FILE" "$SRC_MOUNT/send_snap" > /dev/null 2>&1
    btrfs receive --dump < "$DUMP_FILE" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs receive --dump failed"

    # Step 8: Test btrfs receive from file (use new destination)
    btrfs_setup_loopdev "$DST_LOOP2_FILE" "$DST_MOUNT2" 256
    DST_DEV2="$LOOP_DEV"

    # Step 9: Test btrfs receive basic
    btrfs receive -f "$SNAP_FILE" "$DST_MOUNT2" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs receive -f from file failed"

    # Step 10: Verify received subvolume exists
    btrfs subvolume list "$DST_MOUNT2" 2>&1 | grep -q "send_snap"
    CHECK_RESULT $? 0 0 "btrfs receive subvolume verification failed"

    # Step 11: Test btrfs receive with incremental send file
    btrfs receive -f "$SNAP_FILE2" "$DST_MOUNT2" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs receive incremental failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    # Cleanup temporary destination 2
    LOOP_DEV="$DST_DEV2"
    btrfs_cleanup_loopdev "$DST_LOOP2_FILE" "$DST_MOUNT2"

    # Cleanup send files
    btrfs_cleanup_files "$SNAP_FILE" "$SNAP_FILE2" "$NODATA_FILE" "$CLONE_FILE" "$QUIET_FILE" "$DUMP_FILE"

    # Cleanup destination
    LOOP_DEV="$DST_LOOP_DEV"
    btrfs_cleanup_loopdev "$DST_LOOP_FILE" "$DST_MOUNT"

    # Cleanup source
    LOOP_DEV="$SRC_LOOP_DEV"
    btrfs_cleanup_loopdev "$SRC_LOOP_FILE" "$SRC_MOUNT"

    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
