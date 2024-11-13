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
# @Desc      :   gdisk test for sgdisk change disk guid function
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
	pre_guid=$(sgdisk -p "$unused_disk" | grep GUID | awk '{print $NF}')
	sgdisk -U 0 "$unused_disk"
	CHECK_RESULT $?
	after_guid=$(sgdisk -p "$unused_disk" | grep GUID | awk '{print $NF}')
	[ "$after_guid" == "00000000-0000-0000-0000-000000000000" ]
	CHECK_RESULT $?
	sgdisk -U "$pre_guid" "$unused_disk"
	CHECK_RESULT $?
}

function post_test() {
	DNF_REMOVE
}

main "$@"
