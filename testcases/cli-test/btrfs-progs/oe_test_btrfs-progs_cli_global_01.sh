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
# @Desc      :   btrfs global options and filesystem basics test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_glob01_test.img"
MOUNT_POINT="/tmp/btrfs_glob01_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256
    btrfs_create_test_data "$MOUNT_POINT" 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== btrfs global options tests =====
    # Step 1: Test btrfs -v verbose version
    local version_output
    version_output=$(btrfs -v version 2>&1)
    echo "$version_output" | grep -q "btrfs-progs"
    CHECK_RESULT $? 0 0 "btrfs -v version failed"

    # Step 2: Test btrfs --format json version
    local json_output
    json_output=$(btrfs --format json version 2>&1)
    echo "$json_output" | grep -q "btrfs-progs"
    CHECK_RESULT $? 0 0 "btrfs --format json version failed"

    # Step 3: Test btrfs --quiet version
    btrfs --quiet version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs --quiet version failed"

    # Step 4: Test btrfs --help output
    btrfs --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs --help failed"

    # Step 5: Test btrfs global help contains options
    local help_output
    help_output=$(btrfs --help 2>&1)
    echo "$help_output" | grep -q "version"
    CHECK_RESULT $? 0 0 "btrfs global help version check failed"

    # Step 6: Test btrfs global help contains filesystem command
    echo "$help_output" | grep -q "filesystem"
    CHECK_RESULT $? 0 0 "btrfs global help filesystem check failed"

    # ===== btrfs filesystem basic tests =====
    # Step 7: Test btrfs filesystem df - basic execution
    btrfs filesystem df "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem df failed"

    # Step 8: Test btrfs filesystem df output verification
    local df_output
    df_output=$(btrfs filesystem df "$MOUNT_POINT" 2>&1)
    echo "$df_output" | grep -q "Data"
    CHECK_RESULT $? 0 0 "btrfs filesystem df output verification failed"

    # Step 9: Test btrfs filesystem usage
    btrfs filesystem usage "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem usage failed"

    # Step 10: Test btrfs filesystem usage output verification
    local usage_output
    usage_output=$(btrfs filesystem usage "$MOUNT_POINT" 2>&1)
    echo "$usage_output" | grep -q "Device size"
    CHECK_RESULT $? 0 0 "btrfs filesystem usage output verification failed"

    # Step 11: Test btrfs filesystem show
    btrfs filesystem show "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem show failed"

    # Step 12: Test btrfs filesystem show output verification
    local show_output
    show_output=$(btrfs filesystem show "$MOUNT_POINT" 2>&1)
    echo "$show_output" | grep -q "uuid"
    CHECK_RESULT $? 0 0 "btrfs filesystem show output verification failed"

    # Step 13: Test btrfs filesystem sync
    btrfs filesystem sync "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem sync failed"

    # Step 14: Test btrfs filesystem label set and get
    btrfs filesystem label "$MOUNT_POINT" GLOB01_LABEL > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem label set failed"

    # Step 15: Verify label
    local label_output
    label_output=$(btrfs filesystem label "$MOUNT_POINT" 2>&1)
    echo "$label_output" | grep -q "GLOB01_LABEL"
    CHECK_RESULT $? 0 0 "btrfs filesystem label get failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
