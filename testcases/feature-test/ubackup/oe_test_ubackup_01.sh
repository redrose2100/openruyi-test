#!/usr/bin/bash
# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhangjinqiang
# @Contact   :   jinqiang.oerv@isrc.iscas.ac.cn
# @Date      :   2025/09/03
# @License   :   Mulan PSL v2
# @Desc      :   ubackup data system 备份还原测试
# ############################################
# shellcheck disable=SC2120
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    disks=$(TEST_DISK "$@")
    disk_list=("$disks")
    local_disk=${disk_list[0]}

    DNF_INSTALL "com.deepin.backup"

    rm -rf /data/test
    umount /mnt

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    echo -e "g\nn\n\n\n\nw\n" | fdisk "/dev/${local_disk}"
    CHECK_RESULT $?

    mkfs.ext4 -F "/dev/${local_disk}1"
    CHECK_RESULT $?

    mount "/dev/${local_disk}1" /mnt
    CHECK_RESULT $?
    mkdir -pv /mnt/backup
    CHECK_RESULT $?

    ubackup --help
    CHECK_RESULT $?


    mkdir -pv /data/test
    CHECK_RESULT $?
    touch /data/test/1
    CHECK_RESULT $?

    data_snapshot_id=$(ubackup backup data -r /mnt/backup --include /data/test | grep -E 'snapshot.*saved' | awk '{print $2}')
    [ -n "$data_snapshot_id" ]
    CHECK_RESULT $?

    ubackup logs | grep "$data_snapshot_id" | grep "data backup |true"
    CHECK_RESULT $?

    ls /mnt/backup/snapshots/"$data_snapshot_id"*
    CHECK_RESULT $?

    ubackup list
    CHECK_RESULT $?


    sudo rm /data/test/1
    CHECK_RESULT $?

    ubackup restore data -n "$data_snapshot_id"
    CHECK_RESULT $?

    test -f /data/test/1
    CHECK_RESULT $?

    ubackup logs | grep "$data_snapshot_id" | grep "full restore |true"
    CHECK_RESULT $?

    ubackup remove -l "$data_snapshot_id"
    CHECK_RESULT $?

    ubackup logs | grep "$data_snapshot_id" | grep "remove |true"
    CHECK_RESULT $?

    system_snapshot_id=$(ubackup backup system -r /mnt/backup | grep -E 'snapshot.*saved' | awk '{print $2}')
    [ -n "$system_snapshot_id" ]
    CHECK_RESULT $?

    ubackup logs | grep "$system_snapshot_id" | grep "system backup |true"
    CHECK_RESULT $?

    # ubackup restore system -n "$system_snapshot_id"
    # CHECK_RESULT $?

    ubackup remove -l "$system_snapshot_id"
    CHECK_RESULT $?

    ubackup logs | grep "$system_snapshot_id" | grep "remove |true"
    CHECK_RESULT $?

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."

    sudo rm -rf /data/test/
    umount /mnt

    DNF_REMOVE "$@"

    LOG_INFO "Finish environment cleanup!"
}

main "$@"
