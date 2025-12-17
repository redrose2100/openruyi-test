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
#@Author    	:   lufei
#@Contact   	:   lufei@uniontech.com
#@Date      	:   2023-07-12
#@License   	:   Mulan PSL v2
#@Desc      	:   Make squashfs test
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL "squashfs-tools"
    mkdir ./test_squashfs
    echo "helloworld" > ./test_squashfs/testfile
    LOG_INFO "Finish to prepare the database config."
}

function run_test() {
    LOG_INFO "Start to run test."
    mksquashfs ./test_squashfs ./test_squashfs.squashfs
    CHECK_RESULT $? 0 0 "mksquashfs failed"
    mount ./test_squashfs.squashfs /mnt
    CHECK_RESULT $? 0 0 "mount squashfs failed"
    grep "helloworld" /mnt/testfile
    CHECK_RESULT $? 0 0 "read file failed"
    touch /mnt/testfile
    CHECK_RESULT $? 0 1 "touched file on readonly fs"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /mnt
    rm -rf ./test_squashfs.squashfs ./test_squashfs
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
