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
# @Desc      :   libsemanage Python bindings test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "python3-libsemanage"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 1: Verify python3-libsemanage package is installed
	rpm -qa | grep -w python3-libsemanage
	CHECK_RESULT $? 0 0 "python3-libsemanage package not installed"

	# Step 2: Test Python import
	python3 -c "import semanage; print('semanage module imported successfully')"
	CHECK_RESULT $? 0 0 "Failed to import semanage module"

	# Step 3: Test semanage module version/info
	python3 -c "import semanage; print('semanage version:', semanage.__file__)"
	CHECK_RESULT $? 0 0 "Failed to get semanage module info"

	# Step 4: Test semanage handle creation (if SELinux is enabled)
	if ! sestatus 2>/dev/null | grep -q "SELinux status:.*enabled"; then
		setenforce 1
		if ! getenforce | grep -q "Enforcing"; then
			LOG_INFO "SELinux is not enabled, skipping handle test"
			exit 255
		fi
	else
		python3 -c "
import semanage
h = semanage.semanage_handle_create()
if h:
    semanage.semanage_handle_destroy(h)
    print('Handle creation and destruction successful')
else:
    raise Exception('Failed to create handle')
"
		CHECK_RESULT $? 0 0 "Failed to create semanage handle"
	fi

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
