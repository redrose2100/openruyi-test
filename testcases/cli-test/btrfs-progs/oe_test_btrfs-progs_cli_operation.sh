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
# @Desc      :   btrfs operation test - balance, scrub, property actual execution
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

# Global variables
LOOP_FILE="/tmp/btrfs_op_test.img"
MOUNT_POINT="/tmp/btrfs_op_test_mnt"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    btrfs_setup_loopdev "$LOOP_FILE" "$MOUNT_POINT" 128
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== Property tests =====
    # Step 1: Set compression property
    btrfs property set "$MOUNT_POINT" compression zlib > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs property set compression failed"

    # Step 2: Get compression property
    btrfs property get "$MOUNT_POINT" 2>&1 | grep "compression=zlib"
    CHECK_RESULT $? 0 0 "btrfs property get compression failed"

    # Step 3: Set compression property to lzo
    btrfs property set "$MOUNT_POINT" compression lzo > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs property set compression lzo failed"

    # Step 4: Get compression property after change
    btrfs property get "$MOUNT_POINT" 2>&1 | grep "compression=lzo"
    CHECK_RESULT $? 0 0 "btrfs property get compression lzo failed"

    # Step 5: List available properties
    btrfs property list "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs property list failed"

    # ===== Balance tests =====
    # Step 6: Create test data for balance
    dd if=/dev/urandom of="$MOUNT_POINT/testdata.bin" bs=1M count=10 > /dev/null 2>&1

    # Step 7: Start balance with -dusage filter
    btrfs balance start -dusage=10 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs balance start failed"

    # Step 8: Check balance status
    btrfs balance status "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs balance status failed"

    # Step 9: Start balance with -musage filter
    btrfs balance start -musage=10 "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs balance start -musage failed"

    # ===== Scrub tests =====
    # Step 10: Start scrub
    btrfs scrub start "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs scrub start failed"

    # Step 11: Check scrub status
    local scrub_output
    scrub_output=$(btrfs scrub status "$MOUNT_POINT" 2>&1)
    echo "$scrub_output" | grep "UUID"
    CHECK_RESULT $? 0 0 "btrfs scrub status failed"

    # Step 12: Check scrub shows no errors
    echo "$scrub_output" | grep "no errors found"
    CHECK_RESULT $? 0 0 "btrfs scrub no errors check failed"

    # Step 13: Test scrub status after completion
    btrfs scrub status "$MOUNT_POINT" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs scrub status after completion failed"

    # ===== Defragment test =====
    # Step 14: Create file for defragment test
    dd if=/dev/zero of="$MOUNT_POINT/defrag_test.bin" bs=1M count=5 > /dev/null 2>&1

    # Step 15: Run defragment on file
    btrfs filesystem defragment "$MOUNT_POINT/defrag_test.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment failed"

    # Step 16: Run defragment with -f option
    btrfs filesystem defragment -f "$MOUNT_POINT/defrag_test.bin" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem defragment -f failed"

    # ===== Resize test =====
    # Step 17: Test resize help
    btrfs filesystem resize --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs filesystem resize help failed"

    # Step 18: Test resize help output verification
    local resize_help
    resize_help=$(btrfs filesystem resize --help 2>&1)
    echo "$resize_help" | grep -q "max"
    CHECK_RESULT $? 0 0 "btrfs filesystem resize help verification failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "$MOUNT_POINT/testdata.bin" "$MOUNT_POINT/defrag_test.bin"
    btrfs_cleanup_loopdev "$LOOP_FILE" "$MOUNT_POINT"
	DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"