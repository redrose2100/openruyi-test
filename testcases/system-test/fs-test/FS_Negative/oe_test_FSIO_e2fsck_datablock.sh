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
#@Date      	:   2021-04-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Fsck ext3/ext4
#####################################

source ../common_lib/fsio_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL dump
    point_list=($(CREATE_FS "ext3 ext4"))
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        echo $i >$mnt_point/$i
        mkdir -p $mnt_point/test_dir$i/$i
        dump -0uj -f /tmp/$i.bak.gz $mnt_point
    done
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(seq 1 $((${#point_list[@]} - 1))); do
        mnt_point=${point_list[$i]}
        lv=$(df -T | grep $mnt_point | awk '{print $1}')
        dd if=/dev/zero of=$lv bs=1 count=4096
        umount $mnt_point
        fsck $lv -f -y
        mount $lv $mnt_point
        ls -l $mnt_point/lost+found
        CHECK_RESULT $? 0 0 "The lost+found on $mnt_point doesn't exist."
        restore -rf /tmp/$i.bak.gz
        grep $i $mnt_point/$i
        CHECK_RESULT $? 0 0 "The file is restored failed."
        ls -l $mnt_point/test_dir$i | grep $i
        CHECK_RESULT $? 0 0 "The direcotry is restored failed."
	rm -rf test_dir* 1 2 restoresymtable lost+found
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    list=$(echo ${point_list[@]})
    REMOVE_FS "$list"
    DNF_REMOVE dump
    rm -rf /tmp/*.bak.gz 
    LOG_INFO "End to restore the test environment."
}

main "$@"

