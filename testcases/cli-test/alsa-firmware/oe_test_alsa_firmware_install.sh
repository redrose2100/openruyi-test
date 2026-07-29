#!/usr/bin/bash

# Copyright (c) 2026 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   ding_jiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2026-07-29
# @License   :   Mulan PSL v2
# @Desc      :   Test alsa-firmware package installation integrity
# ############################################
# shellcheck disable=SC2119

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "alsa-firmware"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Test 1: Verify package is installed
    rpm -q alsa-firmware > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "alsa-firmware package not installed"

    # Test 2: Verify package integrity check (permissions, ownership, checksum)
    rpm -V alsa-firmware > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Package integrity check failed (rpm -V)"

    # Test 3: Verify package contains files
    file_count=$(rpm -ql alsa-firmware 2>/dev/null | wc -l)
    [ "$file_count" -gt 0 ]
    CHECK_RESULT $? 0 0 "Package contains no files"

    # Test 4: Verify documentation directory exists
    [ -d "/usr/share/doc/alsa-firmware" ]
    CHECK_RESULT $? 0 0 "Documentation directory missing"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
