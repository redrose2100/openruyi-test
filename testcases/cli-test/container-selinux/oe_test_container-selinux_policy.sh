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
# @Desc      :   container-selinux policy verification test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "container-selinux setools-console"
    
    # Step 1: Check if SELinux is enabled
	if ! sestatus 2>/dev/null | grep -q "SELinux status:.*enabled"; then
		setenforce 1
		if ! getenforce | grep -q "Enforcing"; then
			LOG_INFO "SELinux is not enabled. Skipping policy verification tests."
			exit 255
		fi
	fi
    
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # Step 2: Check SELinux mode
    sestatus | grep "Current mode"
    CHECK_RESULT $? 0 0 "Failed to get SELinux mode"
    
    # Step 3: Verify container-selinux policy is loaded
    semodule -l | grep container
    CHECK_RESULT $? 0 0 "container-selinux policy not loaded"
    
    # Step 4: Verify container SELinux types
    seinfo -t | grep -i container
    CHECK_RESULT $? 0 0 "Failed to get container SELinux types"
    
    # Step 5: Verify container SELinux booleans
    getsebool -a | grep -i container
    CHECK_RESULT $? 0 0 "Failed to get container SELinux booleans"
    
    # Step 6: Check container_t domain exists
    seinfo -t container_t > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "container_t type not found"
    
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"