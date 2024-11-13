#!/usr/bin/bash
# Copyright (c) 2023. xFusion Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.
# #############################################
# @Author    :   liyongqiang
# @Contact   :   liyongqiang@xfusion.com
# @Date      :   2023/11/5
# @License   :   Mulan PSL v2
# @Desc      :   gdisk change partition name test
# #############################################
#shellcheck disable=SC2120,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/gdisk/common_lib.sh

function pre_test() {
	DNF_INSTALL gdisk
	get_unused_disk
	[ -z "$unused_disk" ] && echo "no unused disk" && exit 1
}

function run_test() {
	create_partition
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $?
	expect <<-END
		log_file gdisk_info
		spawn gdisk $unused_disk
		expect "*help):"
		send "p\r"
		expect "*help):"
		send "c\r"
		expect "Enter name:"
		send "test_name\r"
		expect "*help):"
		send "p\r"
		expect "*help):"
		send "q\r"
		expect eof
		exit
	END
	grep "8300 test_name" gdisk_file
	delete_partition
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $? 0 1
}

function post_test() {
	rm -rf gdisk_info
	DNF_REMOVE gdisk
}

main "$@"
