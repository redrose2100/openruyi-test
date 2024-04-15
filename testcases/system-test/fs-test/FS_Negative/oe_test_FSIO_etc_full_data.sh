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
#@Desc      	:   Inject data full on /etc
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start to run test."
    echo "test" >/etc/testFile1 && grep "test" /etc/testFile1 >/dev/null
    CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
    df -T | grep "/$" | grep "root" | awk '{print $6}' | grep -v "100%"
    CHECK_RESULT $? 0 0 "The device is fulled."
    free_space=$(df -T | grep "/$" | grep root | awk '{print $5}')
    dd if=/dev/zero of=/etc/test_fullfile bs="$free_space" count="$free_space"
    df -T | grep "/$" | grep "root" | awk '{print $6}' | grep "100%"
    CHECK_RESULT $? 0 0 "The device isn't full but cannot write data."
    cp /etc/testFiletest_fullfile1 /etc/test_fullfile2
    CHECK_RESULT $? 1 0 "Write data into device unexpectly."
    rm -f /etc/test_fullfile
    echo "test" >/etc/testFile2 && grep "test" /etc/testFile2 >/dev/null
    CHECK_RESULT $? 0 0 "Read or write file failed befor injection."
    df -T | grep "/$" | grep "root" | awk '{print $6}' | grep -v "100%"
    CHECK_RESULT $? 0 0 "The device is fulled."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /etc/testFile1 /etc/testFile2
    LOG_INFO "End to restore the test environment."
}

main "$@"

