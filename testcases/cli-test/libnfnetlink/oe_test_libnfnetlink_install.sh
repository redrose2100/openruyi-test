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
# @Date      :   2026/08/07
# @License   :   Mulan PSL v2
# @Desc      :   test libnfnetlink package installation
# ############################################

# shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libnfnetlink libnfnetlink-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Test 1: Verify runtime library file exists
    find /usr/lib64 -name "libnfnetlink.so*" | grep -q "libnfnetlink"
    CHECK_RESULT $? 0 0 "libnfnetlink runtime library not found"
    
    # Test 2: Verify development library file exists
    find /usr/lib64 -name "libnfnetlink.so" | grep -q "libnfnetlink.so"
    CHECK_RESULT $? 0 0 "libnfnetlink development library not found"
    
    # Test 3: Verify header files exist
    test -f "/usr/include/libnfnetlink/libnfnetlink.h"
    CHECK_RESULT $? 0 0 "libnfnetlink.h header file not found"
    test -f "/usr/include/libnfnetlink/linux_nfnetlink.h"
    CHECK_RESULT $? 0 0 "linux_nfnetlink.h header file not found"
    
    # Test 4: Verify pkg-config file exists
    test -f "/usr/lib64/pkgconfig/libnfnetlink.pc"
    CHECK_RESULT $? 0 0 "libnfnetlink.pc pkg-config file not found"
    
    # Test 5: Verify pkg-config works correctly
    pkg-config --exists libnfnetlink
    CHECK_RESULT $? 0 0 "pkg-config libnfnetlink not found"
    pkg-config --libs libnfnetlink | grep -q "lnfnetlink"
    CHECK_RESULT $? 0 0 "pkg-config --libs libnfnetlink failed"
    pkg-config --cflags libnfnetlink
    CHECK_RESULT $? 0 0 "pkg-config --cflags libnfnetlink failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
