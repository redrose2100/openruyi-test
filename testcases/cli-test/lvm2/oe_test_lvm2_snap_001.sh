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
# @Date      :   2024-10-26
# @License   :   Mulan PSL v2
# @Desc      :   lvm-snap test
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
    lvcreate -L 2G -s -n lv_snap_test /dev/vg_test/lv_test
    CHECK_RESULT $? 0 0 'snap is creat success'
}
function post_test() {
    LOG_INFO "Start environment cleanup."
    lvremove -y /dev/vg_test/lv_snap_test
    umount /home/snap_$$
    rm -rf /home/snap_$$
    lvremove -y /dev/vg_test/lv_test
    vgremove -y vg_test
    pvremove -f /dev/"${local_disk}"
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}

main "$@"
