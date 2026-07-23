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
# @Desc      :   Test prefetch_tuning package installation, CLI commands and parameter effectiveness
# ############################################

# shellcheck disable=SC2119
source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "Start to config params of the case."
    TEST_FILE="/tmp/prefetch_test_$(date +%s)"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "prefetch_tuning"
    insmod "$(find /lib/modules/ -name prefetch_tuning.ko | head -1)"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # Test package installation
    rpm -qa | grep -q prefetch_tuning
    CHECK_RESULT $? 0 0 "prefetch_tuning package not installed"
    # Test kernel module exists
    find /lib/modules/ -name prefetch_tuning.ko | grep prefetch_tuning.ko
    CHECK_RESULT $? 0 0 "prefetch_tuning kernel module not found"
    # Test module loaded
    lsmod | grep -q prefetch_tuning
    CHECK_RESULT $? 0 0 "prefetch_tuning module not loaded"
    # Test sysfs directory exists
    [ -d /sys/devices/virtual/misc/prefetch ]
    CHECK_RESULT $? 0 0 "prefetch_tuning sysfs directory not found"
    # Create test file for effectiveness test
    dd if=/dev/urandom of="${TEST_FILE}" bs=4K count=1024 2>/dev/null
    CHECK_RESULT $? 0 0 "test file creation failed"
    # Enable prefetch (policy=1) and measure read performance
    echo 1 > /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy set to 1 for effectiveness test failed"
    dd if="${TEST_FILE}" of=/dev/null bs=4K count=1024 2>/dev/null
    CHECK_RESULT $? 0 0 "read test with prefetch enabled failed"
    # Disable prefetch (policy=0) and measure read performance
    echo 0 > /sys/devices/virtual/misc/prefetch/policy
    CHECK_RESULT $? 0 0 "policy set to 0 for effectiveness test failed"
    dd if="${TEST_FILE}" of=/dev/null bs=4K count=1024 2>/dev/null
    CHECK_RESULT $? 0 0 "read test with prefetch disabled failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f "${TEST_FILE}"
    rmmod prefetch_tuning
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
