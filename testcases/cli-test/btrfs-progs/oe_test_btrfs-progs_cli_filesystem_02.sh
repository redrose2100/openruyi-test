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
# @Desc      :   btrfs filesystem defragment/resize test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_fs02_test.img"
MOUNT_POINT="/tmp/btrfs_fs02_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 256
    btrfs_create_test_data "$MOUNT_POINT" 10
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== filesystem defragment tests =====
    # Step 1: Test btrfs filesystem defragment on file
    btrfs filesystem defragment "$MOUNT_POINT/testdata.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment failed"

    # Step 2: Test btrfs filesystem defragment with -f force option
    btrfs filesystem defragment -f "$MOUNT_POINT/testdata.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment -f failed"

    # Step 3: Test btrfs filesystem defragment -r recursive on directory
    btrfs filesystem defragment -r "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment -r failed"

    # Step 4: Test btrfs filesystem defragment -c zlib compression option
    btrfs filesystem defragment -czlib "$MOUNT_POINT/testdata.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment -c failed"

    # Step 5: Test btrfs filesystem defragment -l len option
    btrfs filesystem defragment -l 1024 "$MOUNT_POINT/testdata.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment -l failed"

    # ===== filesystem resize tests =====
    # Step 6: Test btrfs filesystem resize with max keyword
    btrfs filesystem resize max "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem resize max failed"

    # Step 7: Test btrfs filesystem resize help
    btrfs filesystem resize --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem resize help failed"

    # Step 8: Test btrfs filesystem resize help output verification
    local resize_help
    resize_help=$(btrfs filesystem resize --help 2>&1)
    echo "$resize_help" | grep -q "max"
    CHECK_RESULT $? 0 0 "btrfs filesystem resize options check failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
