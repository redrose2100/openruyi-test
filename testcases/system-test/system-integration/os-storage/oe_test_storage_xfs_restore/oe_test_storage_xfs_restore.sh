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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-10
# @License   :   Mulan PSL v2
# @Desc      :   Restore XFS file system from backup
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
source ../common/storage_disk_lib.sh
function config_params() {
    LOG_INFO "Start loading data!"
    check_free_disk 1
    ADD_DISK="/dev/${disk_list[0]}"
    LOG_INFO "Loading data is complete!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL xfsdump
    echo "n

p


+20M
w" | fdisk "${ADD_DISK}"
    sleep 2
    mkfs.xfs -f "${ADD_DISK}"1
    sleep 2
    udevadm settle
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase."
    mkdir /home/data /home/backup /opt/data
    mount "${ADD_DISK}"1 /home/data
    echo "test" >/home/data/test
    echo "backup_data
1
" | xfsdump -l 0 -f /home/backup/data.xfsdump /home/data
    CHECK_RESULT $?
    xfsrestore -f /home/backup/data.xfsdump /opt/data
    CHECK_RESULT $?
    cat /opt/data/test
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /home/data
    rm -rf /home/data /home/backup /opt/data
    echo "d

w" | fdisk "${ADD_DISK}"
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup."
}

main $@
