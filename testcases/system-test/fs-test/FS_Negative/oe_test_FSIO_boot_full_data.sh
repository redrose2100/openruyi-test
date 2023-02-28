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
#@Date      	:   2021-01-13
#@License   	:   Mulan PSL v2
#@Desc      	:   Inject data full on /boot
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "Start to run before inject."
    echo "test" > /boot/testFile1 && grep -q "test" /boot/testFile1 >/dev/null
    CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
    df -T | grep "/boot" | grep -v "/boot/" | awk '{print $6}' | grep -v "100%" 
    CHECK_RESULT $? 0 0 "The device is fulled."
    LOG_INFO "End to run before inject."
    LOG_INFO "Start to run inject."
    free_space=$(df -T | grep /boot | awk '{print $5}' | head -n 1)
    dd if=/dev/zero of=/boot/test_fullfile bs=$free_space count=$free_space
    df -T | grep "/boot" | grep -v "/boot/" | awk '{print $6}' | grep "100%" 
    CHECK_RESULT $? 0 0 "The device isn't full but cannot write data."
    cp /boot/test_fullfile /boot/test_fullfile2
    CHECK_RESULT $? 1 0 "Write data into device unexpectly."
    LOG_INFO "End to run inject."
    LOG_INFO "Start to run after revert inject."
    rm -f /boot/test_fullfile
    echo "test" > /boot/testFile3 && grep -q "test" /boot/testFile3
    CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
    df -T | grep "/boot" | grep -v "/boot/" | awk '{print $6}' | grep -v "100%" 
    CHECK_RESULT $? 0 0 "The device is fulled."
    LOG_INFO "End to run after revert inject."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /boot/testFile1 /boot/testFile2 /boot/testFile3
    cd -
    LOG_INFO "End to restore the test environment."
}

main "$@"

