#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   linmengmeng
# @Contact   :   linmengmeng@huawei.com
# @Date      :   2024-10-29
# @License   :   Mulan PSL v2
# @Desc      :   lvm-snap delete test
# ############################################
source ./common/disk_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL lvm2
    check_free_disk
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    pvcreate -y /dev/"${local_disk}"
    CHECK_RESULT $? 0 0 'pv is creat success'
    vgcreate -y vg_test /dev/"${local_disk}"
    CHECK_RESULT $? 0 0 'vg is creat success'
    lvcreate -y -L 2G -n lv_test vg_test
    CHECK_RESULT $? 0 0 'lv is creat success'
    mkfs.ext4 -F /dev/vg_test/lv_test
    CHECK_RESULT $? 0 0 'mkfs is creat success'
    mkdir -p /home/snap_$$
    mount /dev/vg_test/lv_test /home/snap_$$
    CHECK_RESULT $? 0 0 'mount is success'
    lvchange --refresh vg_test/lv_test
    lvcreate -L 1G -s -n lv_snap_test_1 /dev/vg_test/lv_test
    CHECK_RESULT $? 0 0 'snap 1 is creat success'
    lvcreate -L 1G -s -n lv_snap_test_2 /dev/vg_test/lv_test
    CHECK_RESULT $? 0 0 'snap 2  is creat success'
    dmsetup status | grep "lv_snap_test_1:.*snapshot"
    CHECK_RESULT $? 0 0 'snap1 snapshot info is right'
    dmsetup status | grep "lv_snap_test_2:.*snapshot"
    CHECK_RESULT $? 0 0 'snap2 snapshot info is right'
    dmsetup status | grep "lv_snap_test_1-cow:.*linear"
    CHECK_RESULT $? 0 0 'snap1 linear info is right'
    dmsetup status | grep "lv_snap_test_2-cow:.*linear"
    CHECK_RESULT $? 0 0 'snap2 linear info is right'
    dmsetup status | grep "lv_test:.*snapshot-origin"
    CHECK_RESULT $? 0 0 'snap1 snapshot-origin info is right'
    dmsetup status | grep "lv_test:.*snapshot-origin"
    CHECK_RESULT $? 0 0 'snap2 snapshot-origin info is right'
    dmsetup status | grep "lv_test-real:.*linear"
    CHECK_RESULT $? 0 0 'snap1-real info is right'
    dmsetup status | grep "lv_test-real:.*linear"
    CHECK_RESULT $? 0 0 'snap2-real info is right'

    LOG_INFO "delete snap1"
    lvremove -y /dev/vg_test/lv_snap_test_1
    CHECK_RESULT $? 0 0 'snap 1 is delete success'
    dmsetup status | grep "lv_snap_test_1:.*snapshot"
    CHECK_RESULT $? 0 1 'snap1 snapshot info is right'
    dmsetup status | grep "lv_snap_test_1-cow:.*linear"
    CHECK_RESULT $? 0 1 'snap1 linear info is right'

    LOG_INFO "delete snap2"
    lvremove -y /dev/vg_test/lv_snap_test_2
    dmsetup status | grep "lv_snap_test_2:.*snapshot"
    CHECK_RESULT $? 0 1 'snap2 snapshot info is right'
    dmsetup status | grep "lv_snap_test_2-cow:.*linear"
    CHECK_RESULT $? 0 1 'snap2 linear info is right'

    LOG_INFO "check all snap info"
    dmsetup status | grep "lv_test:.*snapshot-origin"
    CHECK_RESULT $? 0 1 'snapshot-origin info is right'
    dmsetup status | grep "lv_test-real:.*linear"
    CHECK_RESULT $? 0 1 'real info is right'
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    umount /home/snap_$$
    rm -rf /home/snap_$$
    lvremove -y /dev/vg_test/lv_test
    vgremove -y vg_test
    pvremove -f /dev/"${local_disk}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
