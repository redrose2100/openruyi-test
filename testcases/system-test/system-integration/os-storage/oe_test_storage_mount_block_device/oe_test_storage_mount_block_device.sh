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
# @Desc      :   Mount through fast device and installation point
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


+20M
w" | fdisk "${ADD_DISK}"
    mkfs.xfs -f "${ADD_DISK}"1
    CHECK_RESULT $?
    sleep 2
    udevadm settle
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mkdir /home/data
    cp /etc/fstab /etc/fstab.bak
    echo "${ADD_DISK}1 /home/data xfs defaults 0 0" >>/etc/fstab
    mount /home/data
    df -h | grep '/home/data'
    CHECK_RESULT $?
    umount /home/data
    mount "${ADD_DISK}"1
    df -h | grep '/home/data'
    CHECK_RESULT $?
    umount /home/data
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /home/data
    mv /etc/fstab.bak /etc/fstab -f
    echo "d

w" | fdisk "${ADD_DISK}"
    LOG_INFO "Finish environment cleanup."
}

main $@
