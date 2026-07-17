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
# @Date      :   2026-07-15
# @License   :   Mulan PSL v2
# @Desc      :   nss-mdns install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "nss-mdns"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 1: Verify nss-mdns package is installed
    rpm -qa | grep -w nss-mdns
    CHECK_RESULT $? 0 0 "nss-mdns package not installed"
    
    # Step 2: Verify NSS module files exist
    ls /usr/lib64/libnss_mdns4_minimal.so*
    CHECK_RESULT $? 0 0 "libnss_mdns4_minimal.so not found"
    
    # Step 3: Verify mdns4 module exists
    ls /usr/lib64/libnss_mdns4.so*
    CHECK_RESULT $? 0 0 "libnss_mdns4.so not found"
    
    # Step 4: Verify mdns6 module exists (IPv6 support)
    ls /usr/lib64/libnss_mdns6.so*
    CHECK_RESULT $? 0 0 "libnss_mdns6.so not found"
    
    # Step 5: Verify mdns6_minimal module exists
    ls /usr/lib64/libnss_mdns6_minimal.so*
    CHECK_RESULT $? 0 0 "libnss_mdns6_minimal.so not found"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"