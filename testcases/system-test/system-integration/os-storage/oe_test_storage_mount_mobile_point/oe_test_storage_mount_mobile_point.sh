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
# @Desc      :   Mobile mount point
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 2
    ADD_DISK="/dev/${disk_list[0]}"
    ADD_DISK_C="/dev/${disk_list[1]}"
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    mkfs.xfs -f "${ADD_DISK}"
    sleep 2
    mkfs.xfs -f "${ADD_DISK_C}"
    sleep 2
    udevadm settle
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mount "${ADD_DISK_C}" /mnt
    mount --make-private /mnt
    CHECK_RESULT $?
    mkdir /mnt/data /mnt/boot
    mount "${ADD_DISK}" /mnt/data
    CHECK_RESULT $? 0 0 "mount"
    findmnt -o TARGET,PROPAGATION /mnt | grep private
    CHECK_RESULT $? 0 0 "private"
    mount --move /mnt/data /mnt/boot
    CHECK_RESULT $? 0 0 "mount move"
   
    findmnt | grep "${ADD_DISK}" | grep "/mnt/boot"
    CHECK_RESULT $? 0 0 "add_disk"
    ls /home/mugen/libs/locallibs/mugen_log.py 
    pwd
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    mount --move /mnt/boot /mnt/data
    umount /mnt/boot
    umount /mnt/data
    mount --make-share /mnt
    umount /mnt
    SLEEP_WAIT 3
    rm -rf /mnt/data /mnt/boot
    LOG_INFO "Finish environment cleanup."
}

main $@
