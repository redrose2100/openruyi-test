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
# @Desc      :   Test alsa-firmware load capability
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

    # Test 1: Verify kernel standard firmware loading path exists
    [ -d "/lib/firmware" ]
    CHECK_RESULT $? 0 0 "Kernel firmware path /lib/firmware not available"

    # Test 2: Verify all package firmware files are in standard search path
    missing=0
    checked=0
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        checked=$((checked + 1))
        [ -e "$f" ] || { LOG_ERROR "Firmware missing from load path: $f"; missing=1; }
    done < <(rpm -ql alsa-firmware 2>/dev/null | grep -E '^/(lib|usr/share/alsa)/firmware/')
    [ $checked -gt 0 ]
    CHECK_RESULT $? 0 0 "No firmware files found in standard search path"
    CHECK_RESULT $missing 0 0 "Some firmware files missing from standard load path"

    # Test 3: Check dmesg for firmware loading errors if sound device exists
    if [ -d "/sys/class/sound" ] && [ -n "$(ls -A /sys/class/sound 2>/dev/null)" ]; then
        if command -v dmesg > /dev/null 2>&1; then
            fw_errors=$(dmesg 2>/dev/null | grep -ciE "firmware.*(fail|error|not found).*(snd|audio|alsa)" || true)
            [ "$fw_errors" -eq 0 ]
            CHECK_RESULT $? 0 0 "Firmware loading errors detected in dmesg"
        fi
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
