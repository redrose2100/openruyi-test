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
# @Date      :   2020-04-27
# @License   :   Mulan PSL v2
# @Desc      :   Query disk attributes: lsblk
# ############################################
source "${OET_PATH}"/testcases/system-test/system-integration/os-storage/common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    if [ ! -e /dev/openeuler/swap ];then
        LOG_WARN "Testing cannot be performed if /dev/openeuler/swap not exist."
        exit 255
    fi
    DNF_INSTALL xfsprogs
    new_uuid=12d59867-ff81-40d8-a7e7-45e971d31255
    value=$(lsblk | grep openeuler | sed -n '$p' | awk -F '└─' '{split($2,a," "); print a[1]}')
    LOG_INFO "Loading data is complete!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mkfs.ext4 -F /dev/"${local_disk}"
    sleep 2
    lsblk --fs "/dev/${local_disk}" |awk '{if (NR>1){print$NF}}' | grep -E '[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}'
    CHECK_RESULT $?
    lsblk --output +UUID /dev/"${local_disk}" | awk '{if (NR>1){print$NF}}' | grep -E '[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}'
    CHECK_RESULT $?

    mkfs.ext4 -F /dev/"${local_disk1}"
    CHECK_RESULT $?
    tune2fs -U ${new_uuid} -L new-label /dev/"${local_disk1}"
    udevadm settle
    sleep 2
    lsblk --output +UUID /dev/"${local_disk1}" | awk '{if (NR>1){print$NF}}' | grep "${new_uuid}"
    CHECK_RESULT $?
    mkfs.xfs -f /dev/"${local_disk1}"
    CHECK_RESULT $?
    xfs_admin -U ${new_uuid} -L new-label /dev/"${local_disk1}"
    udevadm settle
    sleep 2
    lsblk --output +UUID /dev/"${local_disk1}" | awk '{if (NR>1){print$NF}}' | grep ${new_uuid}
    CHECK_RESULT $?
    swapoff /dev//mapper/"${value}"
    swaplabel -U ${new_uuid} -L new-label /dev/mapper/"${value}"
    udevadm settle
    sleep 2
    lsblk --fs /dev/mapper/"${value}" | awk '{if (NR>1){print$NF}}' | grep ${new_uuid}
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    swapon -a
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup."
}


main "$@"
