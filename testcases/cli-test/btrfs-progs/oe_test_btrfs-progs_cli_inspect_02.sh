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
# @Desc      :   btrfs device/replace test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_ins02_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_ins02_test_mnt"
REPLACE_FILE="/tmp/btrfs_replace_test.img"
REPLACE_DEV=""

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256

    # Create replace target device (larger)
    dd if=/dev/zero of="$REPLACE_FILE" bs=1M count=512 > /dev/null 2>&1
    REPLACE_DEV=$(losetup --find --show "$REPLACE_FILE")
    if [ -z "$REPLACE_DEV" ]; then
        LOG_ERROR "Failed to setup replace device"
        exit 1
    fi

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== Device tests =====
    # Step 1: Show device usage
    btrfs device usage "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device usage failed"

    # Step 2: Show device usage output verification
    local device_usage
    device_usage=$(btrfs device usage "$MOUNT_POINT" 2>&1)
    echo "$device_usage" | grep -q "Data"
    CHECK_RESULT $? 0 0 "btrfs device usage output verification failed"

    # Step 3: Show device stats
    btrfs device stats "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device stats failed"

    # Step 4: Show device stats with path
    btrfs device stats "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device stats path failed"

    # Step 5: Scan for btrfs devices
    btrfs device scan -d "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device scan failed"

    # Step 6: Test btrfs device scan help
    btrfs device scan --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device scan help failed"

    # Step 8: Add new device to filesystem
    btrfs device add "$REPLACE_DEV" "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device add failed"

    # Step 9: Remove device from filesystem
    btrfs device remove "$REPLACE_DEV" "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs device remove failed"

    # ===== Replace tests =====
    # Step 10: Test btrfs replace status
    btrfs replace status "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs replace status failed"

    # Step 11: Test btrfs replace help output verification
    local replace_help
    replace_help=$(btrfs replace --help 2>&1)
    echo "$replace_help" | grep -q "start"
    CHECK_RESULT $? 0 0 "btrfs replace options check failed"

    # Step 12: Test btrfs replace status output
    local replace_status
    replace_status=$(btrfs replace status "$MOUNT_POINT" 2>&1)
    echo "$replace_status" | grep -qi "no replace\|idle\|finished"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    if [ -n "$REPLACE_DEV" ]; then
        losetup -d "$REPLACE_DEV" > /dev/null 2>&1
    fi
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
    rm -f "$REPLACE_FILE"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
