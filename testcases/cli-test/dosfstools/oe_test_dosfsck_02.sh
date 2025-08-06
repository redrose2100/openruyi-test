#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2025-08-04
# @License   :   Mulan PSL v2
# @Desc      :   Filesystem check command testing (ext2/ext4)
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "e2fsprogs"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=/tmp/test_fs.img bs=1M count=10
    mkfs.ext4 -L TEST_LABEL /tmp/test_fs.img
    CHECK_RESULT $? 0 0 "Failed to create ext4 filesystem"
    fsck.ext4 -n /tmp/test_fs.img
    CHECK_RESULT $? 0 0 "Basic filesystem check failed"
    echo "Corrupting filesystem for testing..."
    dd if=/dev/urandom of=/tmp/test_fs.img bs=1k seek=100 count=10 conv=notrunc
    fsck.ext4 -p /tmp/test_fs.img
    CHECK_RESULT $? 0 0 "Failed to repair corrupted filesystem"
    e2label /tmp/test_fs.img NEW_LABEL
    CHECK_RESULT $? 0 0 "Failed to change filesystem label"
    blkid -o value -s LABEL /tmp/test_fs.img | grep "NEW_LABEL"
    CHECK_RESULT $? 0 0 "Filesystem label not changed correctly"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /tmp/test_fs.img
    LOG_INFO "End to restore the test environment."
}

main "$@"