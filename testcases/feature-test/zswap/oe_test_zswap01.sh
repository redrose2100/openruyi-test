#! /usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023-12-04
# @License   :   Mulan PSL v2
# @Desc      :   For testing kernel zswap feature, by detecting swap cache 
#                usage when zswap enabled.
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "stress-ng sysstat"
    ORIGIN=$(cat /sys/module/zswap/parameters/enabled)
    LOG_INFO "Origin status: $ORIGIN"
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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    test "$SWAP_KB" -eq 0
    CHECK_RESULT $? 0 1 "no available swap." 1
    which stress-ng
    CHECK_RESULT $? 0 0 "stress-ng not found in system" 1
    which sar
    CHECK_RESULT $? 0 0 "sar not found in system" 1
    MEM_GB=$((MEM_KB/1024/1024))
    LOG_INFO "current zswap status: $(cat /sys/module/zswap/parameters/enabled)"
    LOG_INFO "run stress-ng --vm $((MEM_GB/4+1)) --vm-bytes 4G --timeout 10s"
    stress-ng --vm $((MEM_GB/4+1)) --vm-bytes 4G --timeout 10s &
    # sar collect a little longer than stress-ng run, for ensure stress ends.
    local origin_cad_kb=
    origin_cad_kb=$(sar -S 2 5 | grep "Average" | awk '{print $5}')
    LOG_INFO "origin_cad_kb: $origin_cad_kb"
    if [ "$ORIGIN" == "N" ]; then
        echo "Y" > /sys/module/zswap/parameters/enabled
    else
        echo "N" > /sys/module/zswap/parameters/enabled
    fi
    # sleep 5, ensure stress-ng ends
    sleep 5
    LOG_INFO "current zswap status: $(cat /sys/module/zswap/parameters/enabled)"
    LOG_INFO "run stress-ng --vm $((MEM_GB/4+1)) --vm-bytes 4G --timeout 10s"
    stress-ng --vm $((MEM_GB/4+1)) --vm-bytes 4G --timeout 10s &
    local tested_cad_kb=
    tested_cad_kb=$(sar -S 2 5 | grep "Average" | awk '{print $5}')
    LOG_INFO "tested_cad_kb: $tested_cad_kb"
    if [ "$ORIGIN" == "N" ]; then
        expect=1
    else
        expect=0
    fi
    test "$tested_cad_kb" -gt "$origin_cad_kb"
    CHECK_RESULT $? "$expect" 0 "zswap not work as expected."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    export LANG="$ORIGIN_LANG"
    grep tst_swap /proc/swaps && {
        swapoff ./tst_swap
        rm -rf ./tst_swap
    }
    echo "$ORIGIN" > /sys/module/zswap/parameters/enabled
    LOG_INFO "End to clean the test environment."
}

main "$@"
