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
# @Desc      :   btrfs filesystem label/usage/mkswapfile test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_fs03_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_fs03_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256
    btrfs_create_test_data "$MOUNT_POINT" 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== filesystem label tests =====
    # Step 1: Test btrfs filesystem label set on mount point
    btrfs filesystem label "$MOUNT_POINT" TEST_CLI_LABEL > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem label set failed"

    # Step 2: Test btrfs filesystem label get from mount point
    local label_output
    label_output=$(btrfs filesystem label "$MOUNT_POINT" 2>&1)
    echo "$label_output" | grep -q "TEST_CLI_LABEL"
    CHECK_RESULT $? 0 0 "btrfs filesystem label get failed"

    # Step 3: Test btrfs filesystem label set on device (unmounted)
    umount "$MOUNT_POINT" > /dev/null 2>&1
    btrfs filesystem label "$LOOP_DEV" TEST_DEV_LABEL > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem label on device failed"

    # Step 4: Test btrfs filesystem label get from device
    btrfs filesystem label "$LOOP_DEV" 2>&1 | grep -q "TEST_DEV_LABEL"
    CHECK_RESULT $? 0 0 "btrfs filesystem label get from device failed"

    # Remount after label operation
    mount "$LOOP_DEV" "$MOUNT_POINT" > /dev/null 2>&1

    # ===== filesystem usage tests =====
    # Step 5: Test btrfs filesystem usage - basic execution
    btrfs filesystem usage "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem usage failed"

    # Step 6: Test btrfs filesystem usage output verification
    local usage_output
    usage_output=$(btrfs filesystem usage "$MOUNT_POINT" 2>&1)
    echo "$usage_output" | grep -q "Device size"
    CHECK_RESULT $? 0 0 "btrfs filesystem usage output verification failed"

    # Step 7: Test btrfs filesystem usage help
    btrfs filesystem usage --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem usage help failed"

    # ===== filesystem sync and other tests =====
    # Step 8: Test btrfs filesystem sync
    btrfs filesystem sync "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem sync failed"

    # Step 9: Test btrfs filesystem show with label
    btrfs filesystem show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem show failed"

    # Step 10: Test btrfs filesystem df
    btrfs filesystem df "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem df failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
