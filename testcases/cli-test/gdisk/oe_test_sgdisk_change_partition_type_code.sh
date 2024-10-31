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
# @Desc      :   gdisk test for sgdisk change partition type code function
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
	type_code=$(sgdisk -p "$unused_disk" | tail -n 1 | awk '{print $NF}')
	[ "$type_code" == "8300" ]
	CHECK_RESULT $?
	sgdisk -t 1:8200 "$unused_disk"
	CHECK_RESULT $?
	type_code=$(sgdisk -p "$unused_disk" | tail -n 1 | awk '{print $NF}')
	[ "$type_code" == "8200" ]
	CHECK_RESULT $?
	sgdisk -d 1 "$unused_disk"
	CHECK_RESULT $?
	lsblk | grep "${unused_disk#/dev/}1"
	CHECK_RESULT $? 0 1
}

function post_test() {
	DNF_REMOVE
}

main "$@"

