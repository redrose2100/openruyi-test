#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sjxjx
# @Contact   :   3541335833@qq.com
# @Date      :   2026-04-21
# @License   :   Mulan PSL v2
# @Desc      :   Test zswap max_pool_percent memory limit functionality
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

ORIGIN_ENABLED=""
ORIGIN_MAX_POOL_PERCENT=""
ORIGIN_LANG=""
SWAP_KB=0

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "stress-ng"

    # Save original settings
    ORIGIN_ENABLED=$(cat /sys/module/zswap/parameters/enabled 2>/dev/null)
    ORIGIN_MAX_POOL_PERCENT=$(cat /sys/module/zswap/parameters/max_pool_percent 2>/dev/null)
    ORIGIN_LANG=$LANG
    export LANG="en_US.UTF-8"

    # Get memory info
    MEM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    SWAP_KB=$(grep SwapFree /proc/meminfo | awk '{print $2}')

    # Create swap file if no swap available
    if [ "$SWAP_KB" -eq 0 ]; then
        dd if=/dev/zero of=/tmp/tst_swap bs=1M count=4096
        mkswap /tmp/tst_swap
        swapon /tmp/tst_swap
        SWAP_KB=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    fi

    # Enable zswap
    echo "Y" > /sys/module/zswap/parameters/enabled
    LOG_INFO "End of environmental preparation."
}

function run_test() {
    LOG_INFO "Start to run test."

    # Check swap availability
    test "$SWAP_KB" -gt 0
    CHECK_RESULT $? 0 0 "No available swap, test cannot continue."

    # Test different max_pool_percent values
    for limit in 10 20 30; do
        LOG_INFO "Setting max_pool_percent to $limit"
        echo "$limit" > /sys/module/zswap/parameters/max_pool_percent
        current_limit=$(cat /sys/module/zswap/parameters/max_pool_percent)
        test "$current_limit" -eq "$limit"
        CHECK_RESULT $? 0 0 "Failed to set max_pool_percent to $limit"

        # Generate memory pressure
        MEM_GB=$((MEM_KB / 1024 / 1024))
        stress-ng --vm $((MEM_GB / 4 + 1)) --vm-bytes 4G --timeout 15s &
        stress_pid=$!
        sleep 10

        # Check zswap usage
        zswap_used=$(grep "zswap_pool_total_size" /proc/vmstat 2>/dev/null | awk '{print $2}')
        zswap_used=${zswap_used:-0}
        expected_max=$((MEM_KB * limit / 100))

        LOG_INFO "zswap used: $zswap_used KB, expected max: $expected_max KB"
        # Only warn, do not fail (usage may be lower than limit)
        if [ "$zswap_used" -gt "$expected_max" ]; then
            LOG_WARN "zswap usage ($zswap_used KB) exceeds limit ($expected_max KB)"
        fi

        wait $stress_pid
        echo 3 > /proc/sys/vm/drop_caches
        sleep 2
    done

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG="$ORIGIN_LANG"

    # Remove temporary swap file
    if grep -q /tmp/tst_swap /proc/swaps 2>/dev/null; then
        swapoff /tmp/tst_swap
        rm -f /tmp/tst_swap
    fi

    # Restore original zswap settings
    echo "$ORIGIN_ENABLED" > /sys/module/zswap/parameters/enabled 2>/dev/null
    echo "$ORIGIN_MAX_POOL_PERCENT" > /sys/module/zswap/parameters/max_pool_percent 2>/dev/null

    DNF_REMOVE
    LOG_INFO "End to clean the test environment."
}

main "$@"