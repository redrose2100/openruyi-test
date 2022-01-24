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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Modify persistent named properties
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    local_disk=$(check_free_disk 1)
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    echo -e "n\np\n1\n\n+20M\nn\np\n2\n\n+20M\nn\np\n3\n\n+20M\np\nw\n" | fdisk /dev/${local_disk}
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    mkfs.ext2 -F "/dev/${local_disk}"1
    CHECK_RESULT $?
    lsblk --fs "/dev/${local_disk}"1
    CHECK_RESULT $?
    SLEEP_WAIT 3
    tune2fs -U 2222d19b-8674-41ab-9856-ac3d15d1195e -L new-label "/dev/${local_disk}"1
    CHECK_RESULT $?
    SLEEP_WAIT 1
    lable_1=$(lsblk --fs "/dev/${local_disk}"1 | awk '{if (NR>1){print $4}}')
    SLEEP_WAIT 1
    UUID_1=$(lsblk --fs "/dev/${local_disk}"1 | awk '{if (NR>1){print $5}}')
    SLEEP_WAIT 1
    [[ "$lable_1" == "new-label" ]]
    CHECK_RESULT $?
    [[ "$UUID_1" == "2222d19b-8674-41ab-9856-ac3d15d1195e" ]]
    CHECK_RESULT $?
    mkswap "/dev/${local_disk}"2
    CHECK_RESULT $?
    lsblk --fs "/dev/${local_disk}"2
    CHECK_RESULT $?
    SLEEP_WAIT 3
    swaplabel --uuid 11114983-9331-4a61-8123-96ac6a817c41 --label new-label "/dev/${local_disk}"2
    CHECK_RESULT $?
    SLEEP_WAIT 1
    lable_2=$(lsblk --fs "/dev/${local_disk}"2 | awk '{if (NR>1){print $4}}')
    SLEEP_WAIT 1
    UUID_2=$(lsblk --fs "/dev/${local_disk}"2 | awk '{if (NR>1){print $5}}')
    SLEEP_WAIT 1
    [[ "$lable_2" == "new-label" ]]
    CHECK_RESULT $?
    [[ "$UUID_2" == "11114983-9331-4a61-8123-96ac6a817c41" ]]
    CHECK_RESULT $?
    mkfs.xfs -f "/dev/${local_disk}"3
    CHECK_RESULT $?
    lsblk --fs "/dev/${local_disk}"3
    CHECK_RESULT $?
    xfs_admin -U 8888016f-f432-45d9-933b-66f243174bed -L new-label "/dev/${local_disk}"3
    CHECK_RESULT $?
    SLEEP_WAIT 1
    lable_3=$(lsblk --fs "/dev/${local_disk}"3 | awk '{if (NR>1){print $3}}')
    SLEEP_WAIT 1
    UUID_3=$(lsblk --fs "/dev/${local_disk}"3 | awk '{if (NR>1){print $4}}')
    SLEEP_WAIT 1
    [[ "$lable_3" == "new-label" ]]
    CHECK_RESULT $?
    [[ "$UUID_3" == "8888016f-f432-45d9-933b-66f243174bed" ]]
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    echo -e "d\n\nd\n\nd\n\np\nw\n" | fdisk "/dev/${local_disk}"
    LOG_INFO "Finish environment cleanup."
}

main $@
