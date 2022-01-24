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
# @Desc      :   List currently mounted file systems
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
    echo "n

p


+200M
n

p


+200M
w" | fdisk "${ADD_DISK}"
    mkfs.xfs -f "${ADD_DISK}"1
    sleep 1
    mkfs.ext2 -F "${ADD_DISK}"2
    sleep 1
    udevadm settle
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mkdir /home/data_xfs /home/data_ext
    mount "${ADD_DISK}"1 /home/data_xfs
    mount "${ADD_DISK}"2 /home/data_ext
    findmnt | grep "/home/data_xfs"
    CHECK_RESULT $?
    findmnt | grep "/home/data_ext"
    CHECK_RESULT $?
    findmnt --types xfs | grep "/home/data_ext"
    CHECK_RESULT $? 1
    findmnt --types xfs | grep "/home/data_xfs"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /home/data_xfs
    umount /home/data_ext
    rm -rf /home/data_xfs /home/data_ext
    echo "d

d

w" | fdisk "${ADD_DISK}"
    LOG_INFO "Finish environment cleanup."
}

main $@
