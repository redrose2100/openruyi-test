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
# @Desc      :   gdisk test for sgdisk backup and restore function
# #############################################
# shellcheck disable=SC2120,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh
source "${OET_PATH}"/testcases/cli-test/gdisk/common_lib.sh

function pre_test() {
	DNF_INSTALL gdisk
	get_unused_disk
	[ -z "$unused_disk" ] && echo "no unused disk" && exit 1
}

function run_test() {
	sgdisk -n 1:0:+1G "$unused_disk"
	CHECK_RESULT $?
	sgdisk -p "$unused_disk"
	CHECK_RESULT $?
	sgdisk -c 1:"test_disk" "$unused_disk"
	CHECK_RESULT $?
	Name=$(sgdisk -p "$unused_disk" | tail -n 1 | awk '{print $NF}')
	[ "$Name" == "test_disk" ]
	CHECK_RESULT $?

	sgdisk --backup=/tmp/backup_partition "$unused_disk"
	CHECK_RESULT $?
	sgdisk -c 1:"test_disk111" "$unused_disk"
	CHECK_RESULT $?
	Name=$(sgdisk -p "$unused_disk" | tail -n 1 | awk '{print $NF}')
	[ "$Name" == "test_disk111" ]
	sgdisk -l /tmp/backup_partition "$unused_disk"
	CHECK_RESULT $?
	Name=$(sgdisk -p "$unused_disk" | tail -n 1 | awk '{print $NF}')
	[ "$Name" == "test_disk" ]
	CHECK_RESULT $?
	sgdisk -d 1 "$unused_disk"
	CHECK_RESULT $?
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $? 0 1
}

function post_test() {
	rm -rf /tmp/backup_partition
	DNF_REMOVE
}

main "$@"

