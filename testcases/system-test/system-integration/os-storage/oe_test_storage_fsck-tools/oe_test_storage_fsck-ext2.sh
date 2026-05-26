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
# @Date      :   2026-5-25
# @License   :   Mulan PSL v2
# @Desc      :   Command fsck.ext2 test
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing fsck.ext2 parameters..."
    dd if=/dev/zero of=/tmp/tmp_ext2.img bs=1M count=5 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Create ext2 image file failed"
    mkfs.ext2 -F /tmp/tmp_ext2.img
    CHECK_RESULT $? 0 0 "Format to ext2 failed"
    fsck.ext2 -n /tmp/tmp_ext2.img
    CHECK_RESULT $? 0 0 "fsck.ext2 -n failed"
    fsck.ext2 -p /tmp/tmp_ext2.img
    CHECK_RESULT $? 0 0 "fsck.ext2 -p failed"
    fsck.ext2 -y /tmp/tmp_ext2.img
    CHECK_RESULT $? 0 0 "fsck.ext2 -y failed"
    fsck.ext2 -V > test.log 2>&1
    CHECK_RESULT $? 0 0 "fsck.ext2 -V failed"
    grep -i e2fsck test.log
    CHECK_RESULT $? 0 0 "fsck.ext2 -V check failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /tmp/tmp_ext2.img
    LOG_INFO "End to restore the test environment."
}

main "$@"
