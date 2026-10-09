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
# @Date      :   2026-07-16
# @License   :   Mulan PSL v2
# @Desc      :   libsemanage install verification and package check
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "libsemanage libsemanage-devel policycoreutils-python-utils"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 1: Verify libsemanage package is installed
	rpm -qa | grep -w libsemanage
	CHECK_RESULT $? 0 0 "libsemanage package not installed"

	# Step 2: Verify libsemanage-devel package is installed
	rpm -qa | grep libsemanage-devel
	CHECK_RESULT $? 0 0 "libsemanage-devel package not installed"

	# Step 3: Verify libsemanage library file exists
	ls /usr/lib64/libsemanage.so*
	CHECK_RESULT $? 0 0 "libsemanage library not found"

	# Step 4: Verify semanage command exists
	which semanage
	CHECK_RESULT $? 0 0 "semanage command not found"

	# Step 5: Verify semanage configuration file
	ls /etc/selinux/semanage.conf
	CHECK_RESULT $? 0 0 "semanage.conf not found"

	# Step 6: Verify libsemanage pkgconfig file
	ls /usr/lib64/pkgconfig/libsemanage.pc
	CHECK_RESULT $? 0 0 "libsemanage.pc not found"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
