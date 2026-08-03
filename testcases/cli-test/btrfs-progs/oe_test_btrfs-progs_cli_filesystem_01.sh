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
# @Desc      :   btrfs filesystem df/du/show/sync test
# ############################################
# shellcheck disable=SC1090,SC1091,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_fs01_test.img"
LOOP_DEV=""
MOUNT_POINT="/tmp/btrfs_fs01_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256
    btrfs_create_test_data "$MOUNT_POINT" 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== filesystem df tests =====
    # Step 1: Test btrfs filesystem df - basic execution
    btrfs filesystem df "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem df failed"

    # Step 2: Test btrfs filesystem df output verification
    local df_output
    df_output=$(btrfs filesystem df "$MOUNT_POINT" 2>&1)
    echo "$df_output" | grep -q "Data"
    CHECK_RESULT $? 0 0 "btrfs filesystem df output verification failed"

    # Step 3: Test btrfs filesystem df -h human-readable option
    btrfs filesystem df -h "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem df -h failed"

    # ===== filesystem du tests =====
    # Step 4: Test btrfs filesystem du - basic execution
    btrfs filesystem du "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem du failed"

    # Step 5: Test btrfs filesystem du on specific file
    btrfs filesystem du "$MOUNT_POINT/testfile.txt" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem du on file failed"

    # Step 6: Test btrfs filesystem du -s summary option
    btrfs filesystem du -s "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem du -s failed"

    # Step 7: Test btrfs filesystem du --human-readable option
    btrfs filesystem du --human-readable "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem du --human-readable failed"

    # ===== filesystem show tests =====
    # Step 8: Test btrfs filesystem show - basic execution
    btrfs filesystem show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem show failed"

    # Step 9: Test btrfs filesystem show with device
    btrfs filesystem show "$LOOP_DEV" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem show device failed"

    # Step 10: Test btrfs filesystem show output verification
    local show_output
    show_output=$(btrfs filesystem show "$MOUNT_POINT" 2>&1)
    echo "$show_output" | grep -q "uuid"
    CHECK_RESULT $? 0 0 "btrfs filesystem show output verification failed"

    # ===== filesystem sync test =====
    # Step 11: Test btrfs filesystem sync - basic execution
    btrfs filesystem sync "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem sync failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
