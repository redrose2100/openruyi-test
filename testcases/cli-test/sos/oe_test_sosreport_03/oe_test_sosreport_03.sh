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
	sos report --list-profiles
	CHECK_RESULT $?

	arch=$(arch)
	if [ "$arch" == "x86_64" ]; then
		name="sosreport-localhost"
	elif [ "$arch" == "riscv64" ]; then
	 	name="sosreport-openeuler-riscv64"
	fi
	# sleep 120
	expect <<EOF
		spawn sos report --log-size 10 --case-id log-size
		expect "" {send "\r"}
		expect "" {send "\r"}
		sleep 240
		expect eof
EOF
	test -f /var/tmp/$name-log-size-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
		spawn sos report -n dnf,rpm,selinux,dovecot --case-id skip-plugins
		expect "" {send "\r"}
		expect "" {send "\r"}
		sleep 240
		expect eof
EOF
	test -f /var/tmp/$name-skip-plugins-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	# sleep 120
	expect <<EOF
		spawn sos report --no-report --case-id no-report
		expect "" {send "\r"}
		expect "" {send "\r"}
		sleep 240
		expect eof
EOF
	test -f /var/tmp/$name-no-report-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	no_report_file=$(ls /var/tmp/$name-no-report-"$(date +%Y-%m-%d)"-*.tar.xz)
	tar -xvf "${no_report_file}"
	test -f $name-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.html -a -f $name-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.txt -a -f $name-no-report-"$(date +%Y-%m-%d)"-*/sos_reports/sos.json
	CHECK_RESULT $? 1
	# sleep 120
	expect <<EOF
		spawn sos report --note "testnote" --case-id testnote
		expect "" {send "\r"}
		expect "" {send "\r"}
		sleep 240
		expect eof
EOF
	test -f /var/tmp/$name-testnote-"$(date +%Y-%m-%d)"-*.tar.xz
	CHECK_RESULT $?
	sos report -o dnf,rpm,selinux,dovecot --batch --label only-plugins
	CHECK_RESULT $?
	test -f /var/tmp/$name-only-plugins-"$(date +%Y-%m-%d)"-*.tar.xz
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
