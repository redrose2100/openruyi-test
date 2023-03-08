#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2021-03-23
#@License   	:   Mulan PSL v2
#@Desc      	:   Inject: Destory the fs super block to rw the fs
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    point_list=($(CREATE_FS))
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        echo "test file" >$mnt_point/testFile
        lv=$(df -T | grep $mnt_point | awk '{print $1}')
        dd if=/dev/zero of=$lv bs=1 count=4096
        tune2fs -l $lv 2>&1 | grep "Bad magic number in super-block while trying to open $lv"
        CHECK_RESULT $? 0 0 "Destory the fs super block failed on $mnt_point."
        grep "test file" $mnt_point/testFile
        CHECK_RESULT $? 0 0 "Read file on fs failed when destory the super block on $mnt_point."
        type=$(df -T | grep $mnt_point | awk '{print $2}')
        [[ $type -ne "xfs" ]] && {
            mkdir $mnt_point/testDir 2>&1 | grep "Structure needs cleaning"
            CHECK_RESULT $? 0 0 "Mkdir on fs unexpectly when destory the super block on $mnt_point."
        }
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    LOG_INFO "End to restore the test environment."
}

main "$@"

