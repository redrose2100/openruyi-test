#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2021/01/04
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of sosreport command
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL "sos tar"
	LOG_INFO "Finish preparing the test environment."
}

function run_test() {
	LOG_INFO "Start to run test."
	sos report -h | grep -E "usage: sosreport \[options\]|-"
	CHECK_RESULT $?

	arch=$(arch)
	if [ "$arch" == "x86_64" ]; then
		name="sosreport-localhost"
	elif [ "$arch" == "riscv64" ]; then
	 	name="sosreport-openeuler-riscv64"
	fi

	expect <<EOF
        spawn sos report -a --case-id 001
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 500
        expect eof
EOF
	test -f /var/tmp/$name-001-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 150
	expect <<EOF
        spawn sos report --all-logs --case-id 002
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
	test -f /var/tmp/$name-002-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120 
	expect <<EOF
        spawn sos report --all-logs --case-id 003
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
	test -f /var/tmp/$name-003-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	sos report --batch
	CHECK_RESULT $?
	test -f /var/tmp/$name-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
        spawn sos report  --build --case-id build
        expect "" {send "\r"}
        expect "" {send "\r"}
        sleep 240
        expect eof
EOF
	test -d /var/tmp/$name-build-"$(date +%Y-%m-%d)"-*
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
        spawn sos report  --case-id test 
        expect "" {send "\r"}
		expect "" {send "\r"}
        sleep 240
        expect eof
EOF
	test -f /var/tmp/$name-test-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
        spawn sos report  -c never --case-id never
        expect "" {send "\r"}
		expect "" {send "\r"}
        sleep 240
        expect eof
EOF
	test -f /var/tmp/$name-never-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
		spawn sos report --config-file /etc/sos.conf --case-id config
		expect "" {send "\r"}
		expect "" {send "\r"}
		sleep 240
		expect eof
EOF
	test -f /var/tmp/$name-config-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	LOG_INFO "End of the test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	for file in *; do
		if [[ ! $file =~ \.sh$ ]]; then
			rm -rf "$file"
		fi
	done
	rm -rf /var/tmp/sos*
	DNF_REMOVE "$@"
	LOG_INFO "Finish restoring the test environment."
}

main "$@"
