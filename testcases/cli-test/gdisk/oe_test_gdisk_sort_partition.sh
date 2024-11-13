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
# @Date      :   2023/11/20
# @License   :   Mulan PSL v2
# @Desc      :   gdisk test for sort partition
# #############################################
# shellcheck disable=SC2120,SC2119,SC2320

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/gdisk/common_lib.sh

function pre_test() {
	DNF_INSTALL gdisk
	get_unused_disk
	[ -z "$unused_disk" ] && echo "no unused disk" && exit 1
}

function run_test() {
	create_partition 2 10M
	num=$(lsblk | grep -c "${unused_disk#/dev/}")
	CHECK_RESULT "$num" 3
	expect <<-END
		log_file gdisk_info
		spawn gdisk $unused_disk
		expect "*help):"
		send "p\r"
		expect "*help):"
		send "d\r"
		expect "Partition name:"
		send "1\r"
		expect "*help):"
		send "p\r"
		expect "*help):"
		send "s\r"
		expect "*help):"
		send "p\r"
		expect "*help):"
		send "q\r"
		expect eof
		exit
	END
	No=$(grep "Linux filesystem" gdisk_info | tail -n 1 | awk '{print $1}')
	CHECK_RESULT "$No" 1
	for i in $(seq 1 2); do
		delete_partition "$i"
	done
}

function post_test() {
	rm -rf gdisk_info
	DNF_REMOVE
}

main "$@"
