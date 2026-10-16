#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024-4-1
# @License   :   Mulan PSL v2
# @Desc      :   command lscmem
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if [ ! -d "/sys/devices/system/memory" ]; then
        LOG_WARN "Memory hotplug not supported on this platform, skipping test."
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "start to run test."
    lsmem -V | grep lsmem
    CHECK_RESULT $? 0 0 "show version"
    lsmem -J | grep range
    CHECK_RESULT $? 0 0 "output with JSON format"
    lsmem -P | grep RANGE
    CHECK_RESULT $? 0 0 "output with key of value"
    lsmem -a | grep -i memory
    CHECK_RESULT $? 0 0 "list each individual memory block"
    lsmem -b | grep -A 5 RANGE
    CHECK_RESULT $? 0 0 "prints SIZE in bytes"
    lsmem -n | grep -i memory
    CHECK_RESULT $? 0 0 "does not print headings"
    lsmem -r | grep -A 5 RANGE
    CHECK_RESULT $? 0 0 "use the native output format"
    LOG_INFO "End to run test."
}

main "$@"
