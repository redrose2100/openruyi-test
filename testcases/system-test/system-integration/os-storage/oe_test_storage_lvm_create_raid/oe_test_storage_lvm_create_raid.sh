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
# @Desc      :   Create LVM of raidl type
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 4
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    local_disk2=${disk_list[2]}
    local_disk3=${disk_list[3]}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    mkfs.ext4 -F /dev/${local_disk}
    SLEEP_WAIT 2
    mkfs.ext4 -F /dev/${local_disk1}
    SLEEP_WAIT 2
    mkfs.ext4 -F /dev/${local_disk2}
    SLEEP_WAIT 2
    mkfs.ext4 -F /dev/${local_disk3}
    SLEEP_WAIT 2
    pvcreate /dev/${local_disk1} -y
    SLEEP_WAIT 2
    vgcreate openeulertest /dev/${local_disk1} -y
    SLEEP_WAIT 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgextend openeulertest /dev/${local_disk} -y
    SLEEP_WAIT 2
    vgextend openeulertest /dev/${local_disk3} -y
    SLEEP_WAIT 2
    vgextend openeulertest /dev/${local_disk2} -y
    SLEEP_WAIT 2
    expect -c "
    set timeout 30
    log_file testlog
    spawn lvcreate --type raid1 -m 1 -L 50MB -n test openeulertest -y
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    grep -iE 'while executing|error|fail' testlog
    CHECK_RESULT $? 1
    expect -c "
    set timeout 30
    log_file testlog1
    spawn lvcreate --type raid5 -i 3 -L 50MB -n test1 openeulertest -y
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    grep -iE 'while executing|error|fail' testlog1
    CHECK_RESULT $? 1
    expect -c "
    set timeout 30
    log_file testlog2
    spawn lvcreate -y --type raid5 -i 3 -L 50MB -n test2 openeulertest
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    grep -iE 'while executing|error|fail' testlog2
    CHECK_RESULT $? 1
    lvscan | grep "/dev/openeulertest/test"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove openeulertest/test openeulertest/test1 openeulertest/test2 -y
    SLEEP_WAIT 3
    vgremove openeulertest -y
    SLEEP_WAIT 2
    pvremove /dev/${local_disk1} /dev/${local_disk2} /dev/${local_disk} /dev/${local_disk3}
    SLEEP_WAIT 2
    rm -rf testlog*
    LOG_INFO "Finish environment cleanup."
}

main $@
