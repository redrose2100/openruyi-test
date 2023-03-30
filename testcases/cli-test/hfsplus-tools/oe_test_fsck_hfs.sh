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
# @Desc      :   Test fsck.hfs
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
    fsck.hfs -d -p -f $disk_list 2>&1 | grep 'starting'
    CHECK_RESULT $? 0 0 "test fsck.hfs -f failed"
    fsck.hfs -d -p $disk_list 2>&1 | grep 'starting'
    CHECK_RESULT $? 0 0 "test fsck.hfs -p failed"
    fsck.hfs -d -l $disk_list 2>&1 | grep 'fsck_hfs run at'
    CHECK_RESULT $? 0 0 "test fsck.hfs -l failed"
    fsck.hfs -d -m 01777 $disk_list 2>&1 | grep 'Using cacheBlockSize'
    CHECK_RESULT $? 0 0 "test fsck.hfs -m failed"
    fsck.hfs -d -n $disk_list 2>&1 | grep $disk_list
    CHECK_RESULT $? 0 0 "test fsck.hfs -n failed"
    fsck.hfs -d -r $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfs -r failed"
    fsck.hfs -d -y $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfs -y failed"
    fsck.hfs -d -c 512m  $disk_list | grep 'cacheSize=524288K'
    CHECK_RESULT $? 0 0 "test fsck.hfs -c failed"
    fsck.hfs -d -c 512m  $disk_list | grep 'Using '
    CHECK_RESULT $? 0 0 "test fsck.hfs -d failed"
    fsck.hfs -g  $disk_list | grep 'fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfs -g failed"
    fsck.hfs -d -q $disk_list | grep -v '/.*'
    CHECK_RESULT $? 0 0 "test fsck.hfs -q failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
