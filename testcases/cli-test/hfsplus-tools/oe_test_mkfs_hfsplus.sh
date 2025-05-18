#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/3/1
# @License   :   Mulan PSL v2
# @Desc      :   Test fsck.hfsplus
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL hfsplus-tools
    device=$(lsblk -dn -o NAME | grep -vE '^(loop|nbd|ram)' | sed -n '1p')
    disk_list=/dev/"$device"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkfs.hfsplus -N "$disk_list" | grep 'HFS Plus format parameter'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -N failed"
    mkfs.hfsplus -N -J 4056K "$disk_list" | grep 'journal-size: 4056k'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -J failed"
    mkfs.hfsplus -N -D journal-dev "$disk_list" | grep 'HFS Plus format parameters'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -D failed"
    mkfs.hfsplus -N -G 1000 "$disk_list" | grep 'group ID: 1000'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -G failed"
    mkfs.hfsplus -N -U 1000 "$disk_list" | grep 'user ID: 1000'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -U failed"
    mkfs.hfsplus -N -M 755 "$disk_list" | grep 'access mask: 755'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -M failed"
    mkfs.hfsplus -N -b 8192 "$disk_list" | grep 'block-size: 8192'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -b failed"
    mkfs.hfsplus -N -c b=4096 "$disk_list" | grep '4096 blocks'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -c failed"
    mkfs.hfsplus -N -i 17 "$disk_list" | grep 'first free catalog node id: 17'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -i failed"
    mkfs.hfsplus -N -n a=4096 "$disk_list" | grep 'catalog b-tree node size: 8192'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -n failed"
    mkfs.hfsplus -N -v ascii "$disk_list" | grep 'ascii'
    CHECK_RESULT $? 0 0 "test mkfs.hfsplus -v failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
