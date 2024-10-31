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
# @Desc      :   gdisk create partition test
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
	create_partition
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $?
	[ "$(lsblk | grep "${unused_disk#/dev/}1" | awk '{print $4}')" == "5G" ]
	CHECK_RESULT $?
	echo y | mkfs.ext4 "${unused_disk}1"
	CHECK_RESULT $?
	mkdir mount_tmp
	mount "${unused_disk}1" mount_tmp
	CHECK_RESULT $?
	touch mount_tmp/testfile
	CHECK_RESULT $?
	echo 123 > mount_tmp/testfile
	CHECK_RESULT $?
	CHECK_RESULT "$(cat mount_tmp/testfile)" 123
	rm -rf mount_tmp/testfile
	CHECK_RESULT $?
	umount -l mount_tmp
	CHECK_RESULT $?
	delete_partition
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $? 0 1
}

function post_test() {
	rm -rf mount_tmp
	DNF_REMOVE
}

main "$@"

