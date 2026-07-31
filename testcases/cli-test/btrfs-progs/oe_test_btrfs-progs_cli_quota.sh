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
# @Desc      :   btrfs quota and qgroup test - actual command execution
# ############################################
# shellcheck disable=SC1090,SC1091,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_quota_test.img"
MOUNT_POINT="/tmp/btrfs_quota_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 128
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== Quota tests =====
    # Step 1: Enable quota support
    btrfs quota enable "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs quota enable failed"

    # Step 2: Create subvolume for quota test
    btrfs subvolume create "$MOUNT_POINT/quota_vol" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume create for quota failed"

    # Step 3: Create data in subvolume
    dd if=/dev/zero of="$MOUNT_POINT/quota_vol/data.bin" bs=1M count=10 > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create test data failed"

    # Step 4: Rescan quota
    btrfs quota rescan "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs quota rescan failed"

    # Step 5: Show qgroup info
    btrfs qgroup show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show failed"

    # Step 6: Verify qgroup shows entries (check for qgroup IDs)
    btrfs qgroup show "$MOUNT_POINT" 2>&1 | grep -E "^0/"
    CHECK_RESULT $? 0 0 "btrfs qgroup show verification failed"

    # ===== Qgroup create/limit tests =====
    # Step 7: Create a new qgroup
    btrfs qgroup create 1/0 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup create failed"

    # Step 8: Set limit on qgroup
    btrfs qgroup limit 50M 1/0 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup limit failed"

    # Step 9: Verify qgroup with limit
    btrfs qgroup show "$MOUNT_POINT" 2>&1 | grep "1/0"
    CHECK_RESULT $? 0 0 "btrfs qgroup limit verification failed"

    # Step 10: Show qgroup with limits
    btrfs qgroup show -r "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show -r failed"

    # Step 11: Create another subvolume
    btrfs subvolume create "$MOUNT_POINT/quota_vol2" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs subvolume create quota_vol2 failed"

    # Step 12: Assign qgroup
    btrfs qgroup assign 0/256 1/0 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup assign failed"

    # Step 13: Verify assignment
    btrfs qgroup show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show after assign failed"

    # Step 14: Remove qgroup assignment
    btrfs qgroup remove 0/256 1/0 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup remove failed"

    # Step 15: Show qgroup after remove
    btrfs qgroup show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show after remove failed"

    # Step 16: Destroy qgroup
    btrfs qgroup destroy 1/0 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup destroy failed"

    # Step 17: Show qgroup after destroy
    btrfs qgroup show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show after destroy failed"

    # Step 18: Show qgroup with -r option
    btrfs qgroup show -r "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs qgroup show -r failed"

    # ===== Quota disable test =====
    # Step 19: Create test file in quota_vol2
    dd if=/dev/zero of="$MOUNT_POINT/quota_vol2/test.bin" bs=1M count=5 > /dev/null 2>&1

    # Step 20: Disable quota
    btrfs quota disable "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs quota disable failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs subvolume delete "$MOUNT_POINT/quota_vol" > /dev/null 2>&1
    btrfs subvolume delete "$MOUNT_POINT/quota_vol2" > /dev/null 2>&1
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"