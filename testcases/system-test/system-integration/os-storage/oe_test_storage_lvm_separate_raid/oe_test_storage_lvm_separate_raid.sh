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
# @Desc      :   Separate the image of a raid volume and convert it to an LV
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 3
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    local_disk2=${disk_list[2]}
    mkfs.ext4 -F /dev/${local_disk}
    sleep 2
    mkfs.ext4 -F /dev/${local_disk1}
    sleep 2
    mkfs.ext4 -F /dev/${local_disk2}
    sleep 2
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pvcreate -y /dev/${local_disk1} /dev/${local_disk}
    sleep 2
    vgcreate openeulertest /dev/${local_disk1} /dev/${local_disk} -y
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgextend openeulertest /dev/${local_disk2} -y
    CHECK_RESULT $?
    lvcreate --type mirror -m 1 -L 50MB -n test openeulertest -y
    CHECK_RESULT $?
    expect -c "
    set timeout 30
    spawn lvconvert --type raid1 /dev/openeulertest/test
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    expect -c "
    set timeout 30
    spawn lvconvert --type mirror /dev/openeulertest/test
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"

    lvs -a -o name,copy_percent,devices openeulertest | grep test
    CHECK_RESULT $?
    lvconvert --splitmirror 1 -n test1 openeulertest/test /dev/${local_disk1} -y
    CHECK_RESULT $?
    lvs -a -o name,copy_percent,devices openeulertest | grep test1
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test openeulertest/test1
    sleep 2
    vgremove -y openeulertest
    sleep 1
    pvremove /dev/${local_disk1} /dev/${local_disk2} /dev/${local_disk} -y
    sleep 2
    LOG_INFO "Finish environment cleanup."
}

main $@
