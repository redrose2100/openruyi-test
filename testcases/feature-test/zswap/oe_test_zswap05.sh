#! /usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   2401_86190146
# @Contact   :   202422460152@mail.sdu.edu.cn
# @Date      :   2026-04-28
# @License   :   Mulan PSL v2
# @Desc      :   Test zswap parameters configuration including
#                enabled, compressor, max_pool_percent and
#                zpool parameters.
# ############################################
# shellcheck disable=SC1090

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "stress-ng"
    ORIGIN_ENABLED=$(cat /sys/module/zswap/parameters/enabled 2>/dev/null || echo "N")
    ORIGIN_COMPRESSOR=$(cat /sys/module/zswap/parameters/compressor 2>/dev/null || echo "none")
    ORIGIN_MAX_POOL=$(cat /sys/module/zswap/parameters/max_pool_percent 2>/dev/null || echo "20")
    ORIGIN_ZPOOL=$(cat /sys/module/zswap/parameters/zpool 2>/dev/null || echo "none")
    LOG_INFO "Original config: enabled=$ORIGIN_ENABLED, compressor=$ORIGIN_COMPRESSOR, max_pool_percent=$ORIGIN_MAX_POOL, zpool=$ORIGIN_ZPOOL"
    if [ ! -f /sys/module/zswap/parameters/enabled ]; then
        LOG_WARN "zswap module not available"
        exit 255
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    LOG_INFO "Test 1: Check zswap enabled parameter"
    cat /sys/module/zswap/parameters/enabled
    CHECK_RESULT $? 0 0 "Failed to read zswap enabled parameter"

    LOG_INFO "Test 2: Check available compressors"
    if [ -f /sys/module/zswap/parameters/compressor ]; then
        cat /sys/module/zswap/parameters/compressor
        CHECK_RESULT $? 0 0 "Failed to read compressor parameter"
    else
        LOG_WARN "Compressor parameter not available"
    fi

    LOG_INFO "Test 3: Check max_pool_percent parameter"
    if [ -f /sys/module/zswap/parameters/max_pool_percent ]; then
        cat /sys/module/zswap/parameters/max_pool_percent
        CHECK_RESULT $? 0 0 "Failed to read max_pool_percent parameter"
    else
        LOG_WARN "max_pool_percent parameter not available"
    fi

    LOG_INFO "Test 4: Check zpool parameter"
    if [ -f /sys/module/zswap/parameters/zpool ]; then
        cat /sys/module/zswap/parameters/zpool
        CHECK_RESULT $? 0 0 "Failed to read zpool parameter"
    else
        LOG_WARN "zpool parameter not available"
    fi

    LOG_INFO "Test 5: Toggle zswap enabled"
    if [ "$ORIGIN_ENABLED" == "Y" ]; then
        echo "N" >/sys/module/zswap/parameters/enabled
        CHECK_RESULT $? 0 0 "Failed to disable zswap"
        cur_enabled=$(cat /sys/module/zswap/parameters/enabled)
        test "$cur_enabled" == "N"
        CHECK_RESULT $? 0 0 "zswap not disabled correctly"
        echo "Y" >/sys/module/zswap/parameters/enabled
    else
        echo "Y" >/sys/module/zswap/parameters/enabled
        CHECK_RESULT $? 0 0 "Failed to enable zswap"
        cur_enabled=$(cat /sys/module/zswap/parameters/enabled)
        test "$cur_enabled" == "Y"
        CHECK_RESULT $? 0 0 "zswap not enabled correctly"
    fi

    LOG_INFO "Test 6: Modify max_pool_percent"
    if [ -f /sys/module/zswap/parameters/max_pool_percent ]; then
        echo "10" >/sys/module/zswap/parameters/max_pool_percent
        CHECK_RESULT $? 0 0 "Failed to set max_pool_percent"
        cur_pool=$(cat /sys/module/zswap/parameters/max_pool_percent)
        test "$cur_pool" == "10"
        CHECK_RESULT $? 0 0 "max_pool_percent not set correctly"
        echo "$ORIGIN_MAX_POOL" >/sys/module/zswap/parameters/max_pool_percent
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to clean the test environment."
    if [ -f /sys/module/zswap/parameters/enabled ]; then
        echo "$ORIGIN_ENABLED" >/sys/module/zswap/parameters/enabled
    fi
    if [ -f /sys/module/zswap/parameters/max_pool_percent ]; then
        echo "$ORIGIN_MAX_POOL" >/sys/module/zswap/parameters/max_pool_percent
    fi
    DNF_REMOVE "stress-ng"
    LOG_INFO "End to clean the test environment."
}

main "$@"
