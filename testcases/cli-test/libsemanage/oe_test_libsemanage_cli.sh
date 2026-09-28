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
# @Desc      :   libsemanage semanage command line test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "libsemanage policycoreutils-python-utils"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 2: Test semanage --help command
	semanage --help >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage --help failed"

	# Step 3: Test semanage boolean -l (list booleans)
	semanage boolean -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage boolean -l failed"

	# Step 4: Test semanage fcontext -l (list file contexts)
	semanage fcontext -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage fcontext -l failed"

	# Step 5: Test semanage user -l (list SELinux users)
	semanage user -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage user -l failed"

	# Step 6: Test semanage port -l (list ports)
	semanage port -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage port -l failed"

	# Step 7: Test semanage login -l (list login mappings)
	semanage login -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage login -l failed"

	# Step 8: Test semanage interface -l (list network interfaces)
	semanage interface -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage interface -l failed"

	# Step 9: Test semanage permissive -l (list permissive domains)
	semanage permissive -l >/dev/null 2>&1
	CHECK_RESULT $? 0 0 "semanage permissive -l failed"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
