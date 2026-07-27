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
# @Date      :   2026-07-17
# @License   :   Mulan PSL v2
# @Desc      :   gpgme install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gpgme gpgme-devel"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Verify gpgme package is installed
    rpm -qa | grep -w gpgme
    CHECK_RESULT $? 0 0 "gpgme package not installed"
    
	# Step 2: Verify gpgme-devel package is installed
    rpm -qa | grep -w gpgme-devel
    CHECK_RESULT $? 0 0 "gpgme-devel package not installed"

    # Step 3: Verify gpgme library file exists
    ls /usr/lib64/libgpgme.so*
    CHECK_RESULT $? 0 0 "gpgme library not found"
    
    # Step 4: Verify gpgme-tool command exists
    which gpgme-tool
    CHECK_RESULT $? 0 0 "gpgme-tool command not found"
    
    # Step 5: Verify gpgme pkgconfig file
    test -f /usr/lib64/pkgconfig/gpgme.pc || test -f /usr/lib64/pkgconfig/gmp.pc
    CHECK_RESULT $? 0 0 "gpgme.pc or gmp.pc not found"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"