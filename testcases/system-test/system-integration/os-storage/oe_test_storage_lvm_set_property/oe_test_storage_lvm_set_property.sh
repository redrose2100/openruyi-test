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
# @Date      :   2020-05-07
# @License   :   Mulan PSL v2
# @Desc      :   Set the properties of the device used by a raid volume
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 3
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    local_disk2=${disk_list[2]}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    mkfs.ext4 -F /dev/${local_disk}
    sleep 2
    pvcreate /dev/${local_disk} -y
    sleep 2
    vgcreate -y openeulertest /dev/${local_disk}
    sleep 2
    vgextend openeulertest /dev/${local_disk2} /dev/${local_disk1} -y
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    lvcreate --type raid1 -m 1 -L 1G -n test openeulertest -y
    CHECK_RESULT $?
    SLEEP_WAIT 30
    lvchange --writebehind 3 openeulertest
    CHECK_RESULT $?
    SLEEP_WAIT 2
    lvchange --writemostly /dev/${local_disk} openeulertest
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup.."
    lvremove -y openeulertest/test
    sleep 2
    vgremove -y openeulertest
    sleep 2
    pvremove -y /dev/${local_disk} ${local_disk1} /dev/${local_disk2}
    sleep 2
    LOG_INFO "Finish environment cleanup."
}

main $@
