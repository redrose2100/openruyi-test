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
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2024-4-2
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
    lsmem -o RANGE | grep -A 6 RANGE
    CHECK_RESULT $? 0 0 "with start and end address of the memory range to print"
    lsmem -o SIZE | grep -A 6 SIZE
    CHECK_RESULT $? 0 0 "wirh size of the memory range  to print"
    lsmem -o STATE | grep -A 6 STATE
    CHECK_RESULT $? 0 0 "wirh online status of the memory range  to print"
    lsmem -o REMOVABLE | grep -A 6 REMOVABLE
    CHECK_RESULT $? 0 0 "wirh removable to print"
    lsmem -o BLOCK | grep -A 6 BLOCK
    CHECK_RESULT $? 0 0 "wirh memory block number or blocks range to print"
    lsmem -o NODE | grep -A 6 NODE
    CHECK_RESULT $? 0 0 "wirh numa node of memory to print"
    lsmem -o ZONES | grep -A 6 ZONES
    CHECK_RESULT $? 0 0 "wirh valid zones for the memory range to print"
    LOG_INFO "End to run test."
}

main "$@"
