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
# @Date      :   2026-6-9
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.ext4 test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "e2fsprogs"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing fsck.ext4 basic functions..."
    dd if=/dev/zero of=/tmp/test_ext4.img bs=1M count=150 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create ext4 image file failed"
    mkfs.ext4 -F /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Format to ext4 failed"
    fsck.ext4 -n /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 basic check failed"
    fsck.ext4 -f -n /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 -f (force check) failed"
    fsck.ext4 -v -n /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 -v (verbose) failed"
    fsck.ext4 -p /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 -p (auto repair) failed"
    fsck.ext4 -y /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 -y (yes to all) failed"
    fsck.ext4 -f -v -n /tmp/test_ext4.img >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext4 -f -v (combined options) failed"
    LOG_INFO "Finish fsck.ext4 test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/test_ext4.img
    #shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
