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
# @Author    :   duanxuemin
# @Contact   :   52515856@qq.com
# @Date      :   2020-04-27
# @License   :   Mulan PSL v2
# @Desc      :   Split a VG: put one PV in the VG into another PV
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 2
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pvcreate -y /dev/${local_disk1} /dev/${local_disk}
    sleep 2
    vgcreate openeulertest /dev/${local_disk1}
    sleep 2
    lvcreate -L 50MB -n test openeulertest -y
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    pvscan | grep /dev/${local_disk1}
    CHECK_RESULT $?
    vgextend openeulertest /dev/${local_disk} -y
    pvdisplay | grep ${local_disk}
    CHECK_RESULT $?
    pvmove /dev/${local_disk1} /dev/${local_disk}
    CHECK_RESULT $?
    pvscan | grep /dev/${local_disk} | grep openeulertest
    CHECK_RESULT $?
    lvchange -a n /dev/openeulertest/test
    CHECK_RESULT $?
    vgsplit openeulertest openeulertest1 /dev/${local_disk1}
    CHECK_RESULT $?
    vgdisplay
    lvcreate -y -L 1G -n openeuler1 openeulertest1
    CHECK_RESULT $?
    mkfs.ext4 /dev/openeulertest1/openeuler1
    CHECK_RESULT $?
    sleep 2
    mount /dev/openeulertest1/openeuler1 /mnt
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /dev/openeulertest1/openeuler1
    lvremove -y openeulertest/test openeulertest1/openeuler1
    sleep 2
    vgremove -y openeulertest openeulertest1
    sleep 2
    pvremove /dev/${local_disk1} /dev/${local_disk}
    sleep 2
    LOG_INFO "Finish environment cleanup."
}

main $@
