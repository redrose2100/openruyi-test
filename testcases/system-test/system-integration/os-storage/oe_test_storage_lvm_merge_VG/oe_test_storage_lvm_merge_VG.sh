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
# @Desc      :   Merge 2 VGS
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
    pvcreate -y /dev/${local_disk} /dev/${local_disk1}
    sleep 2
    vgcreate openeuler1 /dev/${local_disk}
    sleep 2
    vgcreate openeulertest /dev/${local_disk1}
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgchange --activate n openeulertest
    sleep 2
    vgmerge -v openeuler1 openeulertest
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    vgremove -y openeulertest
    sleep 2
    vgremove -y openeuler1
    sleep 2
    pvremove /dev/${local_disk} /dev/${local_disk1}
    sleep 2
    LOG_INFO "Finish environment cleanup."
}

main $@
