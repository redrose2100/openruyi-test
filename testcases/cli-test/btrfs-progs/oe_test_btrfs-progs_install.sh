#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zjl_long
# @Contact   :   zhu_jinlong@hoperun.com
# @Date      :   2026-07-30
# @License   :   Mulan PSL v2
# @Desc      :   btrfs-progs install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL btrfs-progs
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Step 1: Verify btrfs-progs package is installed
    rpm -qa | grep -w btrfs-progs
    CHECK_RESULT $? 0 0 "btrfs-progs package not installed"

    # Step 2: Verify btrfs-progs package info
    rpm -qi btrfs-progs > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to get btrfs-progs package info"

    # Step 3: Verify btrfs command exists
    command -v btrfs
    CHECK_RESULT $? 0 0 "btrfs command not found"

    # Step 4: Verify mkfs.btrfs command exists
    command -v mkfs.btrfs
    CHECK_RESULT $? 0 0 "mkfs.btrfs command not found"

    # Step 5: Verify btrfs version
    btrfs --version
    CHECK_RESULT $? 0 0 "btrfs version check failed"

    # Step 6: Verify btrfs command help
    btrfs --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "btrfs help check failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"