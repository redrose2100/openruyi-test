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
    fsck.hfsplus -d -p -f $disk_list 2>&1 | grep 'starting'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -f failed"
    fsck.hfsplus -d -p $disk_list 2>&1 | grep 'starting'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -p failed"
    fsck.hfsplus -d -l $disk_list 2>&1 | grep 'run at'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -l failed"
    fsck.hfsplus -d -m 01777 $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -m failed"
    fsck.hfsplus -d -n $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -n failed"
    fsck.hfsplus -d -r $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -r failed"
    fsck.hfsplus -d -y $disk_list 2>&1 | grep 'Executing fsck_hfs'
    CHECK_RESULT $? 0 0 "test fsck.hfsplus -y failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
