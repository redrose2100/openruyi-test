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
#@Desc      	:   Take the test compare install data comparison between dbs when inode full
#####################################
# shellcheck disable=SC1091
# shellcheck disable=SC2034
source ../../common_lib/pkgship_lib.sh
source ../../common_lib/inject_base/inject_full_inode.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    EXECUTE_T="60m"
    ACT_SERVICE
    INIT_CONF ../../common_lib/openEuler_fedora.yaml
    inject_full_inode inject

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pkgship compare -t install -dbs openeuler-lts fedora33 -o /boot/inject 2>&1 | grep "No space left on device"
    CHECK_RESULT $? 0 0 "The message is error when output path is full inode."

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    inject_full_inode_clean inject 
    REVERT_ENV

    LOG_INFO "End to restore the test environment."
}

main "$@"
