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
# @Desc      :   Create private mount point copy
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
    fdisk "${ADD_DISK}" <<EOF
n
p
1

+200M
n
p
2

+200M
w
EOF
    mkfs.ext2 -F "${ADD_DISK}"1
    sleep 2
    mkfs.ext2 -F "${ADD_DISK}"2
    sleep 2
    udevadm settle
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mount --bind /media /media
    CHECK_RESULT $?
    mount --make-private /media
    CHECK_RESULT $?
    mount --bind /media /mnt
    CHECK_RESULT $?
    mkdir /media/cdrom
    mount "${ADD_DISK}"1 /media/cdrom
    echo "test" >/media/cdrom/test
    find /media/cdrom | grep test
    CHECK_RESULT $?
    CHECK_RESULT $(find /mnt/cdrom | wc -l) 1
    mkdir /mnt/flashdisk
    mount "${ADD_DISK}"2 /mnt/flashdisk
    echo "test" >/mnt/flashdisk/test
    CHECK_RESULT $(find /media/flashdisk | wc -l) 1
    find /mnt/flashdisk | grep test
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /mnt/flashdisk
    umount /media/cdrom
    umount /media
    rm -rf /media/cdrom /mnt/flashdisk
    echo "d
1
d
w" | fdisk "${ADD_DISK}"
    LOG_INFO "Finish environment cleanup."

}

main $@
