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
#@Date      	:   2023-11-06
#@License   	:   Mulan PSL v2
#@Desc      	:   Mount tmpfs test
#####################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare test requirements."
    LOG_INFO "Nothing done."
}

function run_test() {
    LOG_INFO "Start to run test."
    mount -t tmpfs swap /mnt -o size=100
    CHECK_RESULT $? 0 0 "mount failed"
    echo "hello world" > /mnt/testfile
    grep "hello world" /mnt/testfile
    CHECK_RESULT $? 0 0 "write or read file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    umount /mnt
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
