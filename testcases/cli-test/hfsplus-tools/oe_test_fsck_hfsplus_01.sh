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

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL hfsplus-tools
    device=$(lsblk | awk -F " " {'print $1'} | head -n 2 | tail -n 1)
    disk_list=/dev/$device
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fsck.hfsplus -u 2>&1 |grep 'usage: fsck.hfsplus'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -u failed"
    version=$(rpm -qa | grep hfsplus-tools | awk 'BEGIN {FS="-"}{print $3}' | tail -n 1)
    fsck.hfsplus -v 2>&1 | grep $version
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -v failed"
    fsck.hfsplus -d -b 4096 $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -b failed"
    fsck.hfsplus -d -B /  $disk_list | grep 'blocks to match'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -B failed"
    fsck.hfsplus -d -c 512m  $disk_list | grep 'cacheSize=524288K'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -c failed"
    fsck.hfsplus -d -c 512m  $disk_list | grep 'Using '
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -d failed"
    fsck.hfsplus -g  $disk_list | grep 'fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -g failed"
    fsck.hfsplus -x  $disk_list | grep '<string>540.1-Linux</string>'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -x failed"
    fsck.hfsplus -d -q $disk_list | grep -v '/.*'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -q failed"
    fsck.hfsplus -d -E $disk_list | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -E failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
