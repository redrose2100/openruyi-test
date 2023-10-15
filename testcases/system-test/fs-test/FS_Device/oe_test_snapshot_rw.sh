#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2021-06-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Create snapshot and rw
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    point_list=($(CREATE_FS))
    group_name=$(vgdisplay | grep "test_vggroup" | grep "VG Name" | tail -n 1 | awk '{print $3}')
    for i in $(seq 1 $((${#point_list[@]}  - 1))); do
        var=${point_list[$i]}
        echo "test write file" > ${var}/test_file
        mkdir ${var}/test_dir
    done
    mkdir /mnt/test_snap_dir 
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]}  - 1))); do
        var=${point_list[$i]}
        lv_name=$(df -iT | grep $var | awk '{print $1}')
        fs_type=$(df -iT | grep $var | awk '{print $2}')
        lvcreate -L 1G -n test_snap -s ${lv_name}
        CHECK_RESULT $? 0 0 "Create snapshot failed."
        if [[ $fs_type == "xfs" ]]; then 
            mount -o nouuid /dev/${group_name}/test_snap /mnt/test_snap_dir 
        else 
            mount /dev/${group_name}/test_snap /mnt/test_snap_dir 
        fi
        CHECK_RESULT $? 0 0 "Mount snapshot failed."
        grep "test" /mnt/test_snap_dir/test_file
        CHECK_RESULT $? 0 0 "Check file in snapshot failed."
        test -d /mnt/test_snap_dir/test_dir
        CHECK_RESULT $? 0 0 "Check directory in snapshot failed."
        umount /mnt/test_snap_dir 
        CHECK_RESULT $? 0 0 "Umount snapshot failed."
        lvremove /dev/${group_name}/test_snap -y
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    rm -rf /mnt/test_snap_dir 
    LOG_INFO "End to restore the test environment."
}

main "$@"

