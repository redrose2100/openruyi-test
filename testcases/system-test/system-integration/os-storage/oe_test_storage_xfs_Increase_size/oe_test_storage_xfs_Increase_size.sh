#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-10
# @License   :   Mulan PSL v2
# @Desc      :   Increase the size of the XFS file system
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 1
    ADD_DISK="/dev/${disk_list[0]}"
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL xfsdump
    echo "n

p


+40M
n

p


+40M
w" | fdisk "${ADD_DISK}"
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mkdir /home/pv
    pvcreate "${ADD_DISK}"1 -y
    sleep 2
    vgcreate test "${ADD_DISK}"1 -y
    sleep 2
    lvcreate -L 20MiB -n lv1 test -y
    CHECK_RESULT $?
    sleep 2
    mkfs.xfs -f /dev/mapper/test-lv1
    CHECK_RESULT $?
    sleep 2
    mount /dev/mapper/test-lv1 /home/pv
    CHECK_RESULT $?
    pvcreate "${ADD_DISK}"2 -y
    sleep 2
    vgextend test "${ADD_DISK}"2 -y
    CHECK_RESULT $?
    sleep 2
    lvextend -L +10MiB /dev/mapper/test-lv1 "${ADD_DISK}"2 -y
    CHECK_RESULT $?
    sleep 2
    xfs_info /home/pv
    lvextend -L +10MiB /dev/mapper/test-lv1 "${ADD_DISK}"2 -y
    CHECK_RESULT $?
    sleep 2
    xfs_growfs /home/pv -D 5500 | grep "blocks changed from 5120 to 5500"
    CHECK_RESULT $?
    xfs_growfs /home/pv | grep "data blocks changed from 5500 to"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /home/pv
    lvremove /dev/test/lv1 -y
    sleep 1
    vgremove /dev/test -y
    sleep 1
    pvremove "${ADD_DISK}"1 "${ADD_DISK}"2
    rm -rf /home/pv
    echo "d

d

w" | fdisk "${ADD_DISK}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@
