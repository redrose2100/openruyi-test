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
# @Desc      :   Change the number of mirrors for the raid volume
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 3
    local_disk=${disk_list[0]}
    local_disk1=${disk_list[1]}
    local_disk3=${disk_list[2]}
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    pvcreate -y /dev/${local_disk1}
    SLEEP_WAIT 2
    vgcreate openeulertest /dev/${local_disk1} -y
    SLEEP_WAIT 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgextend openeulertest /dev/${local_disk} -y
    CHECK_RESULT $?
    sleep 2
    vgextend openeulertest /dev/${local_disk3} -y
    CHECK_RESULT $?
    sleep 2
    lvcreate -L 50MB -n test openeulertest -y
    CHECK_RESULT $?
    sleep 3
    lvextend -L+1G /dev/openeulertest/test -y
    CHECK_RESULT $?
    sleep 5
    lvs -a -o name,copy_percent,devices openeulertest
    CHECK_RESULT $?
    expect -c "
    set timeout 30
    spawn lvconvert -m2 openeulertest/test
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    CHECK_RESULT $?
    lvs -a -o name,copy_percent,devices openeulertest
    CHECK_RESULT $?
    lvs -a -o name,copy_percent,devices openeulertest
    CHECK_RESULT $?
    expect -c "
    set timeout 30
    spawn lvconvert -m2 openeulertest/test /dev/${local_disk3}
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    CHECK_RESULT $?
    lvs -a -o name,copy_percent,devices openeulertest
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test
    SLEEP_WAIT 2
    vgremove -y openeulertest
    SLEEP_WAIT 2
    pvremove /dev/${local_disk1} /dev/${local_disk} /dev/${local_disk3}
    SLEEP_WAIT 2
    LOG_INFO "Finish environment cleanup."
}

main $@
