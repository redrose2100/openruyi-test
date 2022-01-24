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
# @Desc      :   Lv of expansion stripe type
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
    pvcreate -y /dev/${local_disk} /dev/${local_disk1} /dev/${local_disk2}
    SLEEP_WAIT 2
    vgcreate openeulertest /dev/${local_disk} -y
    SLEEP_WAIT 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    lvcreate -n test -L 1G -i 1 openeulertest -y
    SLEEP_WAIT 2
    lvs -a -o +devices | grep test
    CHECK_RESULT $?
    vgextend openeulertest /dev/${local_disk1} -y
    CHECK_RESULT $?
    vgdisplay openeulertest | grep "Cur PV" | grep 2
    CHECK_RESULT $?
    lvextend openeulertest/test -L 2G -y
    CHECK_RESULT $?
    vgextend openeulertest /dev/${local_disk2} -y
    vgdisplay openeulertest | grep "Cur PV" | grep 3
    CHECK_RESULT $?
    lvextend openeulertest/test -L 3G -y
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test
    SLEEP_WAIT 2
    vgremove -y openeulertest
    SLEEP_WAIT 2
    pvremove -y /dev/${local_disk} /dev/${local_disk1} /dev/${local_disk2}
    SLEEP_WAIT 2
    LOG_INFO "Finish environment cleanup."
}

main $@
