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
#@Desc      	:   Test disk read access
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL bc
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    for i in $(ls -l /dev | grep disk | awk '{print $10}'); do
        actual=$(hdparm -t --direct /dev/$i | tail -n 1 | awk '{print $11}')
        echo "$actual" | bc
        CHECK_RESULT $? 0 0 "The device read of $i is slow."
    done
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"
