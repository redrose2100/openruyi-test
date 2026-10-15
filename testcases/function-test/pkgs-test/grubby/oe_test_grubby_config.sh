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
# @Author    :   zhujinlong
# @Contact   :   zhujinlong@163.com
# @Date      :   2026-07-20
# @License   :   Mulan PSL v2
# @Desc      :   grubby configuration management test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL grubby
    if [ -f /boot/grub2/grub.cfg ]; then
        cp -f /boot/grub2/grub.cfg /boot/grub2/grub.cfg.bak.grubby_test
    fi

	# Step 1: Get current default kernel
    default_kernel=$(grubby --default-kernel 2>/dev/null)
    if [ -z "$default_kernel" ]; then
        LOG_INFO "No default kernel found, skipping config tests (container environment)"
        exit 255
    fi

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 2: Get current default index
    grubby --default-index 2>/dev/null
    CHECK_RESULT $? 0 0 "Failed to get default index"
    
    # Step 3: Verify grubby --info output contains expected fields
    grubby --info="$default_kernel" | grep -E "(title|version|initrd|args)" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --info missing expected fields"
    
    # Step 4: Test adding a kernel argument (temporary)
    local test_arg="grubby_test_arg=1"
    grubby --args="$test_arg" --update-kernel="$default_kernel" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to add kernel argument"
    
    # Step 5: Verify the argument was added
    grubby --info="$default_kernel" | grep "$test_arg" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Kernel argument was not added"
    
    # Step 6: Remove the test argument
    grubby --remove-args="$test_arg" --update-kernel="$default_kernel" > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "Failed to remove kernel argument"
    
    # Step 7: Verify the argument was removed
    grubby --info="$default_kernel" | grep "$test_arg" > /dev/null 2>&1
    CHECK_RESULT $? 0 1 "Kernel argument was not removed"
    
    LOG_INFO "End to run test."
}

function post_test() {
    if [ -f /boot/grub2/grub.cfg.bak.grubby_test ]; then
        mv -f /boot/grub2/grub.cfg.bak.grubby_test /boot/grub2/grub.cfg
    fi
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"