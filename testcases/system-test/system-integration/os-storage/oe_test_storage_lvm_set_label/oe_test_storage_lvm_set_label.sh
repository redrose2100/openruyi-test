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
# @Desc      :   Set the label of primary and secondary equipment
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 2
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    mkfs.ext4 -F /dev/${local_disk}
    sleep 2
    mkfs.ext4 -F /dev/${local_disk1}
    sleep 2
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pvcreate -y /dev/${local_disk} /dev/${local_disk1}
    sleep 2
    vgcreate openeulertest /dev/${local_disk} /dev/${local_disk1}
    sleep 2
    lvcreate -L 200M -n test openeulertest --persistent y --major 253 --minor 7788 -y
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    number=$(pvs -o+pv_used 2>&1 | wc -l)
    test "${number}" -gt 3
    CHECK_RESULT $?
    lvchange --persistent y --major 253 --minor 7788 openeulertest/test -y
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove openeulertest/test -y
    sleep 2
    vgremove openeulertest -y
    sleep 2
    pvremove /dev/${local_disk} /dev/${local_disk1} -y
    sleep 2
    LOG_INFO "Finish environment cleanup."
}

main $@
