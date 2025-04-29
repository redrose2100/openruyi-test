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
#@Desc      	:   Create lvm to make swab
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to prepare the database config."
    disk_name=$(fdisk -l | grep "Disk /dev/" | grep -vE 'loop|mapper' | awk -F ' |:|：' '{print $2}' | awk 'NR==2')
    free_swap=$(free -m | grep -i "swap" | awk '{print $4}')
    LOG_INFO "Finish to prepare the database config."
}

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    fdisk "${disk_name}" <<diskEof
n
p
1

100000
w
diskEof
    dm_name="${disk_name}1"
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mkswap "${dm_name}"
    swapon "${dm_name}"
    cur_free_swap=$(free -m | grep -i "swap" | awk '{print $4}')
    [[ $cur_free_swap -gt $free_swap ]]
    CHECK_RESULT $? 0 0 "The new device doesn't add to swap."
    swapon -v | grep "${dm_name}"
    CHECK_RESULT $? 0 0 "Check swap device failed."
    swapoff "${dm_name}"
    CHECK_RESULT $? 0 0 "Remove swap device failed."
    SLEEP_WAIT 3
    cur_free_swap=$(free -m | grep -i "swap" | awk '{print $4}')
    [[ $cur_free_swap -eq $free_swap ]]
    CHECK_RESULT $? 0 0 "The new device doesn't add to swap."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    fdisk "${disk_name}" <<diskEof
d

w
diskEof
    LOG_INFO "End to restore the test environment."
}

main "$@"
