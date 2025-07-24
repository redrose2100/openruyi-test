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
#@Date      	:   2021-06-24
#@License   	:   Mulan PSL v2
#@Desc      	:   Create lvm to check dm info
#####################################
# shellcheck disable=SC1091

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=("$(CREATE_FS)")
    mkdir /mnt/test_snap_dir
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        var=${point_list[$i]}
        lv_name=$(df -iT | grep "$var" | awk '{print $1}')
        fs_type=$(df -iT | grep "$var" | awk '{print $2}')
        blkid >info_log
        grep "$lv_name" info_log | grep "$fs_type"
        CHECK_RESULT $? 0 0 "Check blkid info for $lv_name failed."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=${point_list[*]}
    REMOVE_FS "$list"
    REMOVE_VG "$@"
    rm -rf info_log /mnt/test_snap_dir
    LOG_INFO "End to restore the test environment."
}

main "$@"
