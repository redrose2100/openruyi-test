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
# @Desc      :   Test alsa-firmware file list and permissions
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

    # Test 1: Verify standard firmware directory exists
    [ -d "/lib/firmware" ]
    CHECK_RESULT $? 0 0 "Firmware directory /lib/firmware not found"

    # Test 2: Get all files from package (exclude directories), verify list is non-empty
    file_list=$(rpm -ql alsa-firmware 2>/dev/null | while read -r f; do [ -f "$f" ] && echo "$f"; done)
    [ -n "$file_list" ]
    CHECK_RESULT $? 0 0 "No regular files found in alsa-firmware package"

    # Test 3: Traverse all files: verify existence, readability, non-empty
    fail=0
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        if [ ! -e "$f" ]; then
            LOG_ERROR "Missing file: $f"
            fail=1
        elif [ ! -r "$f" ]; then
            LOG_ERROR "Unreadable file: $f"
            fail=1
        elif [ ! -s "$f" ]; then
            LOG_ERROR "Empty file: $f"
            fail=1
        fi
    done <<< "$file_list"
    CHECK_RESULT $fail 0 0 "Firmware file permission/size check failed"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
