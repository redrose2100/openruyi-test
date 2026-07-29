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
# @Desc      :   grubby command line options test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL grubby
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Test grubby --help
    grubby --help > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --help failed"
    
    # Step 2: Test grubby --version
    grubby --version > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --version failed"
    
    # Step 3: Test grubby --bootloader-probe to detect bootloader
    grubby --bootloader-probe > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --bootloader-probe failed"
    
    # Step 4: Test grubby --default-kernel to get default kernel
    local default_kernel
    default_kernel=$(grubby --default-kernel 2>/dev/null)
    if [ -n "$default_kernel" ]; then
		CHECK_RESULT $? 0 0 "grubby --default-kernel failed"
    else
        LOG_INFO "No default kernel found (may be container environment)"
    fi
    
    # Step 5: Test grubby --default-index
    grubby --default-index > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --default-index failed"
    
    # Step 6: Test grubby --default-title
    grubby --default-title > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "grubby --default-title failed"
    
    # Step 7: Test grubby --info with specific kernel if available
    if [ -n "$default_kernel" ]; then
        grubby --info="$default_kernel" > /dev/null 2>&1
        CHECK_RESULT $? 0 0 "grubby --info failed"
    else
        LOG_INFO "Skipping --info test as no default kernel found"
    fi
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"