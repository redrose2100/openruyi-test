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
# @Date      :   2020-05-06
# @License   :   Mulan PSL v2
# @Desc      :   Add space to logical volume
# ############################################
source ../common/disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    disk_list=($(check_free_disk 2))
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pvcreate -y /dev/${local_disk1}
    pvdisplay | grep "PV Name" | grep /dev/${local_disk1}
    CHECK_RESULT $?
    vgcreate openeulertest /dev/${local_disk1}
    vgdisplay | grep "VG Name" | grep openeulertest
    CHECK_RESULT $?
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgextend openeulertest /dev/${local_disk} -y
    lvcreate -y -L 50MB -n test openeulertest
    lvextend -y -L+1G /dev/openeulertest/test
    CHECK_RESULT $?
    lvresize -y -L+1G /dev/openeulertest/test
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test
    vgremove -y openeulertest
    vgdisplay | grep "VG Name" | grep openeulertest
    pvremove /dev/${local_disk1} /dev/${local_disk}
    pvdisplay | grep "PV Name" | grep /dev/${local_disk1}
    LOG_INFO "Finish environment cleanup."
}

main $@
