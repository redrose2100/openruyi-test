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
#@Author        :   sunqingwei
#@Contact       :   sunqingwei@uniontech.com
#@Date          :   2023-8-31
#@License       :   Mulan PSL v2
#@Desc          :   Repair file system integrity
#####################################
# shellcheck disable=SC1090,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL e2fsprogs
    dd if=/dev/zero of=/home/testzone count=20 bs=10M
    losetup /dev/loop0 /home/testzone
    CHECK_RESULT $? 0 0 "log message: Failed install minimap2 "
}

function run_test() {
    LOG_INFO "Start to run test."
    mkfs.ext4 -F /dev/loop0
    CHECK_RESULT $? 0 0 "formatting fail"
    mount /dev/loop0 /mnt
    CHECK_RESULT $? 0 0 "mount fail"
    echo test >/mnt/testfile
    grep test /mnt/testfile
    CHECK_RESULT $? 0 0 "test fail"
    umount /mnt
    CHECK_RESULT $? 0 0 "umount fail"
    dd if=/dev/zero of=/dev/loop0 bs=512 count=3
    mount /dev/loop0 /mnt
    CHECK_RESULT $? 0 1 "Failure to destroy"
    e2fsck -y /dev/loop0
    mount /dev/loop0 /mnt
    grep test /mnt/testfile
    CHECK_RESULT $? 0 0 "repair fail"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    umount /mnt
    losetup -d /dev/loop0
    rm -rf /home/testzone
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
