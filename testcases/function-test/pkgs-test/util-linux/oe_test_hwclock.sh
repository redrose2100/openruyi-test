#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2024-4-29
# @License   :   Mulan PSL v2
# @Desc      :   Test hwclock
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL util-linux
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    hwclock -r | grep "20"
    CHECK_RESULT $? 0 0 "hwclock -r is failed!"
    hwclock --hctosys
    CHECK_RESULT $? 0 0 "hwclock --hctosys is failed"
    hwclock --systohc 
    CHECK_RESULT $? 0 0 "hwclock --systohc is failed"
    hwclock --utc | grep "20"
    CHECK_RESULT $? 0 0 "hwclock --utc is failed"
    hwclock --localtime | grep "20"
    CHECK_RESULT $? 0 0 "hwclock --localtime is failed"
    LOG_INFO "End of testcase execution!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"