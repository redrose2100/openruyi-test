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
#@Date      	:   2021-06-04
#@License   	:   Mulan PSL v2
#@Desc      	:   raw disk 100
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    free_disk=$(lsblk | grep disk | awk '{print $1}' | tail -n 1)
    disk_name="/dev/"$free_disk
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    fdisk ${disk_name} << diskEof
n
p
1

100000
w
diskEof
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in {1..100}; do 
        raw /dev/raw/raw$i ${disk_name}1 > /dev/null
        CHECK_RESULT $? 0 0 "Create /dev/raw/raw$i failed."
        break
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    for i in {1..100}; do 
        raw /dev/raw/raw$i 0 0 > /dev/null
    done
    fdisk ${disk_name} << diskEof
d

w
diskEof
    LOG_INFO "End to restore the test environment."
}

main "$@"

