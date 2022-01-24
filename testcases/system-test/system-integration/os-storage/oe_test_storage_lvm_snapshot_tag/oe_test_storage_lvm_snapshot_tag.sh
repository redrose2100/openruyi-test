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
# @Desc      :   Using tag to merge snapshots
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
    pvcreate -y /dev/${local_disk}
    sleep 2
    vgcreate openeulertest /dev/${local_disk}
    sleep 2
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    vgextend openeulertest /dev/${local_disk1} -y
    CHECK_RESULT $?
    sleep 2
    lvcreate -y --type mirror -m 1 -L 50MB -n test openeulertest
    sleep 2
    expect -c "
    set timeout 30
    spawn lvconvert --type raid1 /dev/openeulertest/test
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    lvs -a -o name,copy_percent,devices openeulertest | grep test
    CHECK_RESULT $?
    expect -c "
    set timeout 30
    log_file testlog
    spawn lvconvert --splitmirror 1 --trackchanges openeulertest/test
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    CHECK_RESULT $?
    vgchange --addtag lvm_test_tag /dev/openeulertest
    #merge
    cat testlog
    merge_name=$(grep "lvconvert --merge" testlog | awk -F "'" '{print$2}')
    ${merge_name}
    CHECK_RESULT $?

    expect -c "
    set timeout 30
    spawn lvconvert --merge openeulertest  --background
    sleep 5
    expect \"*\[y/n\]*\" {send \"y\r\"}
    expect eof
"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    lvremove -y openeulertest/test
    sleep 2
    vgremove -y openeulertest
    sleep 2
    pvremove -y /dev/${local_disk} ${local_disk1}
    sleep 2
    rm -rf testlog
    LOG_INFO "Finish environment cleanup."
}

main $@
