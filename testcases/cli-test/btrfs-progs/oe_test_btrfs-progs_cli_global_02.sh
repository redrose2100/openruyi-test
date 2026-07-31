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
# @Desc      :   mkfs.btrfs basic options test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== mkfs.btrfs force and label =====
    # Step 1: Test mkfs.btrfs -f force option
    local file1="/tmp/btrfs_glob02_f.img"
    btrfs_mkfs_file "$file1" 128
    CHECK_RESULT $? 0 0 "mkfs.btrfs -f failed"

    # Step 2: Test mkfs.btrfs -L label option
    local file2="/tmp/btrfs_glob02_lbl.img"
    btrfs_mkfs_file "$file2" 128 "-L TEST_LABEL"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -L failed"

    # Step 3: Verify mkfs.btrfs label
    local dev2
    dev2=$(losetup --find --show "$file2")
    if [ -n "$dev2" ]; then
        btrfs filesystem label "$dev2" 2>&1 | grep -q "TEST_LABEL"
        losetup -d "$dev2" > /dev/null 2>&1
    fi

    # ===== mkfs.btrfs data profile options =====
    # Step 4: Test mkfs.btrfs -d single
    local file3="/tmp/btrfs_glob02_ds.img"
    btrfs_mkfs_file "$file3" 128 "-d single"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -d single failed"

    # Step 5: Test mkfs.btrfs -d dup
    local file4="/tmp/btrfs_glob02_dd.img"
    btrfs_mkfs_file "$file4" 256 "-d dup"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -d dup failed"

    # ===== mkfs.btrfs metadata profile options =====
    # Step 6: Test mkfs.btrfs -m single
    local file5="/tmp/btrfs_glob02_ms.img"
    btrfs_mkfs_file "$file5" 128 "-m single"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -m single failed"

    # Step 7: Test mkfs.btrfs -m dup
    local file6="/tmp/btrfs_glob02_md.img"
    btrfs_mkfs_file "$file6" 256 "-m dup"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -m dup failed"

    # ===== mkfs.btrfs other options =====
    # Step 8: Test mkfs.btrfs -s sectorsize
    local file7="/tmp/btrfs_glob02_s.img"
    btrfs_mkfs_file "$file7" 128 "-s 4096"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -s failed"

    # Step 9: Test mkfs.btrfs -n nodesize
    local file8="/tmp/btrfs_glob02_n.img"
    btrfs_mkfs_file "$file8" 128 "-n 8192"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -n failed"

    # Step 10: Test mkfs.btrfs --help options verification
    local mkfs_help
    mkfs_help=$(mkfs.btrfs --help 2>&1)
    echo "$mkfs_help" | grep -q "\-L"
    CHECK_RESULT $? 0 0 "mkfs.btrfs help -L check failed"

    # Step 11: Test mkfs.btrfs help contains -d
    echo "$mkfs_help" | grep -q "\-d"
    CHECK_RESULT $? 0 0 "mkfs.btrfs help -d check failed"

    # Step 12: Test mkfs.btrfs help contains -m
    echo "$mkfs_help" | grep -q "\-m"
    CHECK_RESULT $? 0 0 "mkfs.btrfs help -m check failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_files /tmp/btrfs_glob02_f.img /tmp/btrfs_glob02_lbl.img \
        /tmp/btrfs_glob02_ds.img /tmp/btrfs_glob02_dd.img \
        /tmp/btrfs_glob02_ms.img /tmp/btrfs_glob02_md.img \
        /tmp/btrfs_glob02_s.img /tmp/btrfs_glob02_n.img
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
