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
# @Author    :   Lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025-08-29
# @License   :   Mulan PSL v2
# @Desc      :   Test chcpu basic functionality
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL util-linux
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test help option
    chcpu --help | grep -qi "Usage:"
    CHECK_RESULT $? 0 0 "chcpu --help failed to show Usage"
    
    # Test version option
    chcpu -V | grep -q "chcpu from util-linux"
    CHECK_RESULT $? 0 0 "chcpu -V failed to display version information"
    
    # Test enable CPU with invalid number
    chcpu -e 999
    CHECK_RESULT $? 0 1 "chcpu -e success with invalid CPU number"
    
    # Test disable CPU with invalid number
    chcpu -d 999
    CHECK_RESULT $? 0 1 "chcpu -d success with invalid CPU number"

    # Check if cpu1 is hotpluggable
    if [ "$(cat /sys/devices/system/cpu/cpu1/online)" -eq 1 ]; then
        LOG_INFO "cpu1 is online and is hotpluggable"

        # Test disable cpu1
        chcpu -d 1
        CHECK_RESULT $? 0 0 "chcpu -d 1 failed"
        test "$(cat /sys/devices/system/cpu/cpu1/online)" -eq 0
        CHECK_RESULT $? 0 0 "cpu1 is not disabled"

        # Test enable cpu1
        chcpu -e 1
        CHECK_RESULT $? 0 0 "chcpu -e 1 failed"
        test "$(cat /sys/devices/system/cpu/cpu1/online)" -eq 1
        CHECK_RESULT $? 0 0 "cpu1 is not enabled"
    else
        # Report failure if cpu1 is not hotpluggable
        CHECK_RESULT 0 0 1 "cpu1 is not hotpluggable, current environment is not suitable for test"
    fi
    
    LOG_INFO "End of testcase execution!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
