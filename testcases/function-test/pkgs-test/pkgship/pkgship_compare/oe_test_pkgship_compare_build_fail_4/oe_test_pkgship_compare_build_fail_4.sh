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
#@Author    	:   meitingli
#@Contact   	:   244349477@qq.com
#@Date      	:   2023-07-30
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test compare build data comparison between dbs failed when data full
#####################################
# shellcheck disable=SC1091
source ../../common_lib/pkgship_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    mkdir /temp/test_build && chmod 777 /temp/test_build
    touch /temp/test_build/test_full_data
    free_data=$(df -T | grep '/tmp' | awk '{print $5}')
    dd if=/dev/zero of=/temp/test_build/test_full_data bs="$free_data" count=1

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship compare -t build -dbs openeuler-lts fedora33 -o /temp/test_build 2>&1 | grep "\[ERROR\]"
    CHECK_RESULT $? 0 0 "The message is error when no paramter."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
