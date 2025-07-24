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
#@Desc      	:   Check available dm on system
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    if ! lsblk | grep -q "openeuler"; then
        LOG_ERROR "The case exit because it is not suitable for this device."
        exit 255
    fi
    fdisk -l >fdisk_log
    grep -q "openeuler-root" fdisk_log && grep -q "openeuler-swap" fdisk_log
    CHECK_RESULT $? 0 0 "Check fdisk -l failed."
    dmsetup ls | grep -q "openeuler-root" && dmsetup ls | grep -q "openeuler-swap"
    CHECK_RESULT $? 0 0 "Check dmsetup ls failed."
    dmsetup info
    CHECK_RESULT $? 0 0 "Check dmsetup info failed."
    blkid >blkid_log
    grep -q "openeuler-root" blkid_log && grep -q "openeuler-swap" blkid_log
    CHECK_RESULT $? 0 0 "Check blkid failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f fdisk_log blkid_log
    REMOVE_VG "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
