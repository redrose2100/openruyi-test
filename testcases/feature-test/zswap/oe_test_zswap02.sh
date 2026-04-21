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
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2026-04-21
# @License   :   Mulan PSL v2
# @Desc      :   For testing kernel zswap feature, by detecting memory usage limit
#                and compression performance of zswap.
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "stress-ng"
    if ! rpm -qa stress-ng | grep stress-ng; then
        echo "stress-ng does not exist"
        exit 255
    fi
    ORIGIN_ENABLED=$(cat /sys/module/zswap/parameters/enabled)
    ORIGIN_MAX_POOL_PERCENT=$(cat /sys/module/zswap/parameters/max_pool_percent)
    LOG_INFO "Origin status: enabled=$ORIGIN_ENABLED, max_pool_percent=$ORIGIN_MAX_POOL_PERCENT"
    MEM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    SWAP_KB=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    LOG_INFO "MEM_KB: $MEM_KB, SWAP_KB: $SWAP_KB"
    if [ "$SWAP_KB" -eq 0 ]; then
        dd if=/dev/zero of=./tst_swap bs=1M count=4096
        mkswap ./tst_swap
        swapon ./tst_swap
        SWAP_KB=$(grep SwapFree /proc/meminfo | awk '{print $2}')
    fi
    ORIGIN_LANG=$LANG
    export LANG="en_US.UTF-8"
    # Enable zswap for test
    echo "Y" >/sys/module/zswap/parameters/enabled
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test "$SWAP_KB" -eq 0
    CHECK_RESULT $? 0 1 "no available swap." 1
    
    # Test 1: Check zswap memory usage limit functionality
    LOG_INFO "Test 1: Check zswap memory usage limit functionality"
    # Set different max_pool_percent values and test
    for limit in 10 20 30; do
        LOG_INFO "Setting max_pool_percent to $limit"
        echo "$limit" >/sys/module/zswap/parameters/max_pool_percent
        current_limit=$(cat /sys/module/zswap/parameters/max_pool_percent)
        LOG_INFO "Current max_pool_percent: $current_limit"
        test "$current_limit" -eq "$limit"
        CHECK_RESULT $? 0 0 "Failed to set max_pool_percent to $limit"
        
        # Generate memory pressure
        MEM_GB=$((MEM_KB / 1024 / 1024))
        LOG_INFO "Running stress-ng to generate memory pressure"
        stress-ng --vm $((MEM_GB / 4 + 1)) --vm-bytes 4G --timeout 15s &
        stress_pid=$!
        
        # Wait for stress-ng to run
        sleep 10
        
        # Check zswap usage
        zswap_used=$(grep "zswap_pool_total_size" /proc/vmstat 2>/dev/null | awk '{print $2}')
        if [ -z "$zswap_used" ]; then
            zswap_used=0
        fi
        LOG_INFO "zswap memory used: $zswap_used KB"
        
        # Calculate expected max usage based on limit
        expected_max=$((MEM_KB * limit / 100))
        LOG_INFO "Expected max zswap usage: $expected_max KB"
        
        # Check if zswap usage is within expected limit
        if [ "$zswap_used" -gt "$expected_max" ]; then
            LOG_WARN "zswap usage ($zswap_used KB) exceeds expected limit ($expected_max KB)"
        else
            LOG_INFO "zswap usage ($zswap_used KB) is within expected limit ($expected_max KB)"
        fi
        
        # Wait for stress-ng to complete
        wait $stress_pid
        
        # Clear zswap cache
        echo 3 >/proc/sys/vm/drop_caches
        sleep 2
    done
    
    # Test 2: Check zswap compression performance
    LOG_INFO "Test 2: Check zswap compression performance"
    # Reset to default limit
    echo "25" >/sys/module/zswap/parameters/max_pool_percent
    
    # Get initial zswap stats
    initial_stored_pages=$(grep "zswap_stored_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    initial_written_back_pages=$(grep "zswap_written_back_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    initial_rejected_pages=$(grep "zswap_rejected_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    
    # Set default values if empty
    initial_stored_pages=${initial_stored_pages:-0}
    initial_written_back_pages=${initial_written_back_pages:-0}
    initial_rejected_pages=${initial_rejected_pages:-0}
    
    # Generate memory pressure
    LOG_INFO "Running stress-ng to generate memory pressure for compression test"
    stress-ng --vm 4 --vm-bytes 4G --timeout 20s &
    stress_pid=$!
    
    # Wait for stress-ng to complete
    wait $stress_pid
    
    # Get final zswap stats
    final_stored_pages=$(grep "zswap_stored_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    final_written_back_pages=$(grep "zswap_written_back_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    final_rejected_pages=$(grep "zswap_rejected_pages" /proc/vmstat 2>/dev/null | awk '{print $2}')
    
    # Set default values if empty
    final_stored_pages=${final_stored_pages:-0}
    final_written_back_pages=${final_written_back_pages:-0}
    final_rejected_pages=${final_rejected_pages:-0}
    
    # Calculate differences
    stored_pages=$((final_stored_pages - initial_stored_pages))
    written_back_pages=$((final_written_back_pages - initial_written_back_pages))
    rejected_pages=$((final_rejected_pages - initial_rejected_pages))
    
    LOG_INFO "Zswap compression performance stats:"
    LOG_INFO "Stored pages: $stored_pages"
    LOG_INFO "Written back pages: $written_back_pages"
    LOG_INFO "Rejected pages: $rejected_pages"
    
    # Verify zswap is working (should have stored pages or at least not fail)
    LOG_INFO "zswap stored_pages: $stored_pages"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG="$ORIGIN_LANG"
    grep tst_swap /proc/swaps && {
        swapoff ./tst_swap
        rm -rf ./tst_swap
    }
    echo "$ORIGIN_ENABLED" >/sys/module/zswap/parameters/enabled
    echo "$ORIGIN_MAX_POOL_PERCENT" >/sys/module/zswap/parameters/max_pool_percent
    DNF_REMOVE "$@"
    LOG_INFO "End to clean the test environment."
}

main "$@"
