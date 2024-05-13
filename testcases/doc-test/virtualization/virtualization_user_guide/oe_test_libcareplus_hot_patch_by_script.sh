#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2023-08-24
#@License       :   Mulan PSL v2
#@Desc          :   Create and apply a LibcarePlus hot patch by script
#####################################
# shellcheck disable=SC1091

source common/common_libcareplus.sh

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	pre_env
	DNF_INSTALL "patch make"
	LOG_INFO "End to prepare the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	# Create LibcarePlus hot patches by script
	diff -up foo.c bar.c >foo.patch
	test -f foo.patch
	CHECK_RESULT $? 0 0 "Failed to generate comparison file"
	expect <<-EOF
		log_file testlog
		spawn libcare-patch-make --clean -i 0001 foo.patch
		expect "File to patch:"
		send "foo.c\\n"
		expect eof
	EOF
	grep "MAKING PATCHES" testlog
	CHECK_RESULT $? 0 0 "Failed to make patches"
	test -f patchroot/*.kpatch
	CHECK_RESULT $? 0 0 "Failed to generate hot patches file: foo.kpatch"
	./lpmake/foo &
	CHECK_RESULT $? 0 0 "Failed to run ./lpmake/foo"
	libcare-ctl -v patch -p "$(pidof foo)" ./patchroot/*.kpatch | grep "patch hunk(s) have been successfully applied"
	# Query hot patch
	libcare-ctl info -p "$(pidof foo)" | grep "Applied patch number"
	CHECK_RESULT $? 0 0 "Failed to query the LibcarePlus hot patches"
	# Uninstall hot patch
	libcare-ctl unpatch -p "$(pidof foo)" -i 0001 | grep "patch hunk(s) were successfully cancelled"
	CHECK_RESULT $? 0 0 "Failed to uninstall the LibcarePlus hot patches"
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	clear_env "$@"
	LOG_INFO "End to restore the test environment."
}

main "$@"
