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
# @Desc      :   gpgme command line tool test
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "gpgme gpgme-devel"
	gpgme_version=$(rpm -qa gpgme | awk -F"-" '{print $2}')
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."

	# Step 1: Test gpgme-json --help
	gpgme-json --help 2>&1 | grep -i "Usage"
	CHECK_RESULT $? 0 0 "gpgme-json --help failed"

	# Step 2: Test gpgme-json --lib-version
	gpgme-json --lib-version | grep "$gpgme_version"
	CHECK_RESULT $? 0 0 "gpgme-json --lib-version failed"

	# Step 3: Test gpgme-tool --help
	gpgme-tool --help 2>&1 | grep -i "Usage"
	CHECK_RESULT $? 0 0 "gpgme-tool --help failed"

	# Step 4: Test gpgme-tool --lib-version
	gpgme-tool --lib-version | grep "$gpgme_version"
	CHECK_RESULT $? 0 0 "gpgme-tool --lib-version failed"

	# Step 5: Test gpgme-config --version
	gpgme-config --version | grep "$gpgme_version"
	CHECK_RESULT $? 0 0 "gpgme-config --version failed"

	# Step 6: Test gpgme-config --host
	gpgme-config --version | grep "$gpgme_version"
	CHECK_RESULT $? 0 0 "gpgme-config --version failed"

	# Step 7: Test gpgme-config --host
	gpgme-config --host | grep "${NODE1_FRAME}"
	CHECK_RESULT $? 0 0 "gpgme-config --host failed"

	# Step 8: Test gpgme-config --prefix
	gpgme-config --prefix | grep "/usr"
	CHECK_RESULT $? 0 0 "gpgme-config --prefix failed"

	# Step 9: Test gpgme-config --exec-prefix
	gpgme-config --exec-prefix | grep "/usr"
	CHECK_RESULT $? 0 0 "gpgme-config --exec-prefix failed"

	# Step 10: Test gpgme-config --libs
	gpgme-config --libs | grep "/usr/lib64"
	CHECK_RESULT $? 0 0 "gpgme-config --libs failed"

	# Step 11: Test gpgme-config --cflags
	gpgme-config --cflags
	CHECK_RESULT $? 0 0 "gpgme-config --cflags failed"

	# Step 12: Test gpgme-config --print-lang
	gpgme-config --print-lang | grep "c cpp python qt"
	CHECK_RESULT $? 0 0 "gpgme-config --print-lang failed"

	# Step 13: Test gpgme-config --have-lang
	gpgme-config --have-lang="python"
	CHECK_RESULT $? 0 0 "gpgme-config --have-lang failed"

	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
