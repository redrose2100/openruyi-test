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
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   2025-08-29
# @License   :   Mulan PSL v2
# @Desc      :   vma_stats command testing
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "libvma"

    LOG_INFO "End of environmental preparation!"
}
function run_test() {
    LOG_INFO "Start testing..."

    LOG_INFO "Test 1: Verify vma_stats tool availability"
    which vma_stats >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "vma_stats tool not available"

    LOG_INFO "Test 2: Verify version information"
    vma_stats --version 2>&1 | grep -iq "vmastat"
    CHECK_RESULT $? 0 0 "Version information not available"

    LOG_INFO "Test 3: Check help documentation"
    vma_stats --help 2>&1 | grep -iq "help"
    CHECK_RESULT $? 0 0 "Help documentation not available"

    LOG_INFO "Test 4: Verify library files existence"
    test -f /usr/lib64/libvma.so || test -f /usr/lib/libvma.so
    CHECK_RESULT $? 0 0 "libvma library file not found"

    LOG_INFO "Test 5: Test netstat-like view"
    vma_stats --view=5 --cycles=1 >/dev/null 2>&1
    CHECK_RESULT $? 0 0 "Detailed statistics view failed"

    LOG_INFO "Finish test!"
}
function post_test() {
    LOG_INFO "Start environment cleanup."
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
