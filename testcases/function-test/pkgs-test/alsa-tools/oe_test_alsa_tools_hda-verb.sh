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
# @Desc      :   Test hda-verb command parameters
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-tools"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test -l option: list known verbs
    hda-verb -l 2>&1 | grep -i "known verbs"
    CHECK_RESULT $? 0 0 "hda-verb -l check failed"
    # Test -L option: list known verbs (one per line)
    hda-verb -L 2>&1 | grep -i "GET_STREAM_FORMAT"
    CHECK_RESULT $? 0 0 "hda-verb -L check failed"
    # Test -l shows SET_STREAM_FORMAT
    hda-verb -l 2>&1 | grep -i "SET_STREAM_FORMAT"
    CHECK_RESULT $? 0 0 "hda-verb -l should show SET_STREAM_FORMAT"
    # Test -L outputs more lines than -l
    l_lines=$(hda-verb -l 2>&1 | wc -l)
    L_lines=$(hda-verb -L 2>&1 | wc -l)
    [ "${L_lines}" -gt "${l_lines}" ]
    CHECK_RESULT $? 0 0 "hda-verb -L (${L_lines} lines) should output more lines than -l (${l_lines} lines)"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
