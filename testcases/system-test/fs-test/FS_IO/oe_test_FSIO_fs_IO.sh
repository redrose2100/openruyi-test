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
#@Date      	:   2021-05-13
#@License   	:   Mulan PSL v2
#@Desc      	:   Test io rw on fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL sysstat
    point_list=($(CREATE_FS))
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        lv=$(df -T | grep $mnt_point | awk '{print $1}')
        dm=$(ls -l $lv | awk '{print $11}' | cut -d '/' -f 2)
        dd if=/dev/zero of=$mnt_point/testfile1 bs=512000 count=100 &
        wr=$(iostat | grep $dm | awk '{print $6}')
        [[ $wr -ge 3000 ]] 
        CHECK_RESULT $? 0 0 "read speed slow."
        dd if=$mnt_point/testfile1 of=$mnt_point/testfile2 bs=512000 count=100 &
        ar=$(iostat | grep $dm | awk '{print $7}')
        [[ $ar -ge 6000 ]]
        CHECK_RESULT $? 0 0 "write speed slow."       
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
