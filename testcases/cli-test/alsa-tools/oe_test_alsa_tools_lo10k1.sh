#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/29
# @License   :   Mulan PSL v2
# @Desc      :   Test lo10k1 command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools alsa-utils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    command -v lo10k1
    CHECK_RESULT $? 0 0 "lo10k1 command not found"
    # Test -h option
    lo10k1 -h 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "lo10k1 -h check failed"
    # Test --help option
    lo10k1 --help 2>&1 | grep -i "usage"
    CHECK_RESULT $? 0 0 "lo10k1 --help check failed"
    if aplay -l 2>/dev/null | grep -q "^card"; then
        # Test -i info option
        lo10k1 -i 2>&1 | grep -i "emu10k1x\|info"
        CHECK_RESULT $? 0 0 "lo10k1 -i info option check failed"
        # Test -l list option
        lo10k1 -l 2>&1 | grep -i "emu10k1x\|patch"
        CHECK_RESULT $? 0 0 "lo10k1 -l list option check failed"
        # Test --debug option
        lo10k1 --debug 2>&1 | grep -i "emu10k1x\|debug"
        CHECK_RESULT $? 0 0 "lo10k1 --debug option check failed"
        # Test -P path option
        lo10k1 -P /tmp 2>&1 | grep -i "emu10k1x\|path"
        CHECK_RESULT $? 0 0 "lo10k1 -P path option check failed"
        # Test --dump option
        local dump_file="/tmp/lo10k1_dump.txt"
        lo10k1 --dump "${dump_file}" 2>&1 | grep -i "emu10k1x\|dump"
        CHECK_RESULT $? 0 0 "lo10k1 --dump option check failed"
        test -f "${dump_file}"
        CHECK_RESULT $? 0 0 "lo10k1 dump file not created"
        rm -f "${dump_file}"
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
