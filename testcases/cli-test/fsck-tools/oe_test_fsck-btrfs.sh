#!/usr/bin/bash
# Copyright (c) 2026.Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2026-5-21
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.btrfs test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "btrfs-progs"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing fsck.btrfs basic functions..."
    dd if=/dev/zero of=/tmp/test_btrfs.img bs=1M count=10 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create btrfs image file failed"
    mkfs.btrfs -f /tmp/test_btrfs.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Format to btrfs failed"
    fsck.btrfs /tmp/test_btrfs.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.btrfs check failed"
    fsck.btrfs --help >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.btrfs --help failed"
    LOG_INFO "Finish fsck.btrfs test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_btrfs.img
    #shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
