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
# @Desc      :   List persistent named properties
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    TEST_DISK="/dev/$(check_free_disk 1)"
    mkfs.ext4 -F ${TEST_DISK}
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    UUID=$(lsblk --fs "${TEST_DISK}" | awk '{if (NR>1){print$NF}}')
    echo ${UUID} | grep [a-z,-,0-9]*-[a-z,-,0-9]*
    CHECK_RESULT $?
    fdisk ${TEST_DISK} <<EOF
n
p
1


w
EOF
    mkfs.ext4 -F "${TEST_DISK}1"
    PARTUUID=$(lsblk --output +PARTUUID "${TEST_DISK}1" | awk 'NR==2{print$NF}')
    echo ${PARTUUID} | grep [a-z,-,0-9]*-[a-z,-,0-9]*
    CHECK_RESULT $?
    file /dev/disk/by-id/*
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    fdisk ${TEST_DISK} <<EOF
d
w
EOF
    LOG_INFO "Finish environment cleanup."
}
main $@
