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
# @Date      :   2026-07-14
# @License   :   Mulan PSL v2
# @Desc      :   libssh2 install verification and version check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    # Step 1: Prepare test environment, install libssh2 and libssh2-devel packages
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libssh2 libssh2-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 2: Verify libssh2 package is installed
    rpm -qa | grep libssh2
    CHECK_RESULT $? 0 0 "libssh2 package not installed"
    
    # Step 3: Verify libssh2-devel package is installed
    rpm -qa | grep libssh2-devel
    CHECK_RESULT $? 0 0 "libssh2-devel package not installed"
    
    # Step 4: Verify pkg-config can find libssh2 module and get version
    pkg-config --modversion libssh2
    CHECK_RESULT $? 0 0 "pkg-config libssh2 module not found"
    
    # Step 5: Verify libssh2.so library file exists
    find /usr/lib64/ -name "libssh2.so*" | grep -q "libssh2.so"
    CHECK_RESULT $? 0 0 "libssh2.so not found"
    
    # Step 6: Verify libssh2.h header file exists
    ls /usr/include/libssh2.h
    CHECK_RESULT $? 0 0 "libssh2.h header not found"
    
    LOG_INFO "End to run test."
}

function post_test() {
    # Step 7: Clean up test environment, remove installed packages
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"