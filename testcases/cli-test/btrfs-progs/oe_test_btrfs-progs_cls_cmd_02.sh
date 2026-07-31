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
# @Desc      :   mkfs.btrfs advanced options test
# ############################################
# shellcheck disable=SC1090,SC1091,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"
source "$(dirname "$0")/common_btrfs-progs.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # ===== mkfs.btrfs checksum options =====
    # Step 1: Test mkfs.btrfs --csum crc32c
    local csum_file1="/tmp/btrfs_csum_crc32c.img"
    btrfs_mkfs_file "$csum_file1" 128 "--csum crc32c"
    CHECK_RESULT $? 0 0 "mkfs.btrfs --csum crc32c failed"
    rm -f "$csum_file1"

    # Step 2: Test mkfs.btrfs --csum sha256
    local csum_file2="/tmp/btrfs_csum_sha256.img"
    btrfs_mkfs_file "$csum_file2" 128 "--csum sha256"
    CHECK_RESULT $? 0 0 "mkfs.btrfs --csum sha256 failed"
    rm -f "$csum_file2"

    # ===== mkfs.btrfs features options =====
    # Step 3: Test mkfs.btrfs -O no-holes feature
    local feat_file1="/tmp/btrfs_feat_noholes.img"
    btrfs_mkfs_file "$feat_file1" 128 "-O no-holes"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -O no-holes failed"
    rm -f "$feat_file1"

    # Step 4: Test mkfs.btrfs -O mixed-bg feature with nodesize 4096
    local feat_file2="/tmp/btrfs_feat_mixbg.img"
    btrfs_mkfs_file "$feat_file2" 256 "-n 4096 -O mixed-bg"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -O mixed-bg failed"
    rm -f "$feat_file2"

    # ===== mkfs.btrfs format options =====
    # Step 5: Test mkfs.btrfs -n nodesize option
    local node_file="/tmp/btrfs_node02.img"
    btrfs_mkfs_file "$node_file" 128 "-n 16384"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -n nodesize failed"
    rm -f "$node_file"

    # Step 6: Test mkfs.btrfs -s sectorsize option
    local sector_file="/tmp/btrfs_sector02.img"
    btrfs_mkfs_file "$sector_file" 128 "-s 4096"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -s sectorsize failed"
    rm -f "$sector_file"

    # ===== mkfs.btrfs profile options =====
    # Step 7: Test mkfs.btrfs -d single data profile
    local data_file="/tmp/btrfs_data02.img"
    btrfs_mkfs_file "$data_file" 128 "-d single"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -d single failed"
    rm -f "$data_file"

    # Step 8: Test mkfs.btrfs -m dup metadata profile
    local meta_file="/tmp/btrfs_meta02.img"
    btrfs_mkfs_file "$meta_file" 256 "-m dup"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -m dup failed"
    rm -f "$meta_file"

    # ===== mkfs.btrfs other options =====
    # Step 9: Test mkfs.btrfs -O extref feature
    local extref_file="/tmp/btrfs_extref02.img"
    btrfs_mkfs_file "$extref_file" 128 "-O extref"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -O extref failed"
    rm -f "$extref_file"

    # Step 10: Test mkfs.btrfs -L label option
    local label_file="/tmp/btrfs_label02.img"
    btrfs_mkfs_file "$label_file" 128 "-L SEND02_LABEL"
    CHECK_RESULT $? 0 0 "mkfs.btrfs -L label failed"
    rm -f "$label_file"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    btrfs_cleanup_files /tmp/btrfs_csum_crc32c.img /tmp/btrfs_csum_sha256.img \
        /tmp/btrfs_feat_noholes.img /tmp/btrfs_feat_mixbg.img \
        /tmp/btrfs_node02.img /tmp/btrfs_sector02.img \
        /tmp/btrfs_data02.img /tmp/btrfs_meta02.img \
        /tmp/btrfs_extref02.img /tmp/btrfs_label02.img
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
