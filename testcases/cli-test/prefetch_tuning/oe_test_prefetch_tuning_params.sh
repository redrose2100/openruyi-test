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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/07/16
# @License   :   Mulan PSL v2
# @Desc      :   Test prefetch_tuning parameters valid range and invalid parameter handling
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "prefetch_tuning"
    insmod "$(find /lib/modules/ -name prefetch_tuning.ko | head -1)"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test policy parameter (0~15): prefetch strategy
    echo 1 > /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy set to 1 failed"
    grep -q "^cpu(.*): 1$" /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy value not updated to 1"
    echo 0 > /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy set to 0 failed"
    grep -q "^cpu(.*): 0$" /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy value not updated to 0"
    echo 15 > /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy set to 15 failed"
    grep -q "^cpu(.*): 15$" /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy value not updated to 15"
    echo 16 > /sys/devices/virtual/misc/prefetch/policy
    grep -q "^cpu(.*): 16$" /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 1 "policy should reject value 16"

    # Test read_unique parameter (0/1): cross-NUMA cache access
    echo 0 > /sys/devices/virtual/misc/prefetch/read_unique
    CHECK_RESULT $? 0 0 "read_unique set to 0 failed"
    grep -q "^cpu(.*): 0.$" /sys/devices/virtual/misc/prefetch/read_unique
    CHECK_RESULT $? 0 0 "read_unique value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/read_unique
    CHECK_RESULT $? 0 0 "read_unique set to 1 failed"
    grep -q "^cpu(.*): 1.$" /sys/devices/virtual/misc/prefetch/read_unique
    CHECK_RESULT $? 0 0 "read_unique value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/read_unique
    grep -q "^cpu(.*): 2.$" /sys/devices/virtual/misc/prefetch/read_unique
    CHECK_RESULT $? 0 1 "read_unique should reject value 2"

    # Test spill_en parameter (0/1): L3 cache spill
    echo 0 > /sys/devices/virtual/misc/prefetch/spill_en
    CHECK_RESULT $? 0 0 "spill_en set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/spill_en
    CHECK_RESULT $? 0 0 "spill_en value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/spill_en
    CHECK_RESULT $? 0 0 "spill_en set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/spill_en
    CHECK_RESULT $? 0 0 "spill_en value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/spill_en
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/spill_en
    CHECK_RESULT $? 0 1 "spill_en should reject value 2"

    # Test sqmerge_en parameter (0/1): squeue merge
    echo 0 > /sys/devices/virtual/misc/prefetch/sqmerge_en
    CHECK_RESULT $? 0 0 "sqmerge_en set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/sqmerge_en
    CHECK_RESULT $? 0 0 "sqmerge_en value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/sqmerge_en
    CHECK_RESULT $? 0 0 "sqmerge_en set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/sqmerge_en
    CHECK_RESULT $? 0 0 "sqmerge_en value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/sqmerge_en
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/sqmerge_en
    CHECK_RESULT $? 0 1 "sqmerge_en should reject value 2"

    # Test prefetch_drop_en parameter (0/1): prefetch drop
    echo 0 > /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    CHECK_RESULT $? 0 0 "prefetch_drop_en set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    CHECK_RESULT $? 0 0 "prefetch_drop_en value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    CHECK_RESULT $? 0 0 "prefetch_drop_en set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    CHECK_RESULT $? 0 0 "prefetch_drop_en value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/prefetch_drop_en
    CHECK_RESULT $? 0 1 "prefetch_drop_en should reject value 2"

    # Test tag_rep_alg parameter (0~3): cache line replacement algorithm
    echo 0 > /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg set to 2 failed"
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg value not updated to 2"
    echo 3 > /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg set to 3 failed"
    grep -q "^register(.*): 3.$" /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 0 "tag_rep_alg value not updated to 3"
    echo 4 > /sys/devices/virtual/misc/prefetch/tag_rep_alg
    grep -q "^register(.*): 4.$" /sys/devices/virtual/misc/prefetch/tag_rep_alg
    CHECK_RESULT $? 0 1 "tag_rep_alg should reject value 4"

    # Test lower_power_en parameter (0/1): lower power mode
    echo 0 > /sys/devices/virtual/misc/prefetch/lower_power_en
    CHECK_RESULT $? 0 0 "lower_power_en set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/lower_power_en
    CHECK_RESULT $? 0 0 "lower_power_en value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/lower_power_en
    CHECK_RESULT $? 0 0 "lower_power_en set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/lower_power_en
    CHECK_RESULT $? 0 0 "lower_power_en value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/lower_power_en
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/lower_power_en
    CHECK_RESULT $? 0 1 "lower_power_en should reject value 2"

    # Test dataclean_shut_en parameter (0/1): data clean shutdown
    echo 0 > /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    CHECK_RESULT $? 0 0 "dataclean_shut_en set to 0 failed"
    grep -q "^register(.*): 0.$" /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    CHECK_RESULT $? 0 0 "dataclean_shut_en value not updated to 0"
    echo 1 > /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    CHECK_RESULT $? 0 0 "dataclean_shut_en set to 1 failed"
    grep -q "^register(.*): 1.$" /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    CHECK_RESULT $? 0 0 "dataclean_shut_en value not updated to 1"
    echo 2 > /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    grep -q "^register(.*): 2.$" /sys/devices/virtual/misc/prefetch/dataclean_shut_en
    CHECK_RESULT $? 0 1 "dataclean_shut_en should reject value 2"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rmmod prefetch_tuning
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
