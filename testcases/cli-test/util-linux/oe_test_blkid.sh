#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2024-7-10
# @License   :   Mulan PSL v2
# @Desc      :   Command blkid
# ############################################
# shellcheck disable=SC1090,SC2119
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
	LOG_INFO "Start to prepare the test environment."
	DNF_INSTALL util-linux
	LOG_INFO "End of environmental preparation!"
}

function run_test() {
	LOG_INFO "start to run test."
	DEV=$(df / | awk 'NR==2{print $1}')
	if [ -z "$DEV" ] || [ ! -b "$DEV" ]; then
		LOG_WARN "No valid block device found, skip blkid device tests"
		blkid --help | grep "blkid --label"
		CHECK_RESULT $? 0 0 "BLKID View Help Command Failed"
	else
		blkid | grep "${DEV}"
		CHECK_RESULT $? 0 0 "List all block devices failed"
		blkid "${DEV}" | grep "${DEV}"
		CHECK_RESULT $? 0 0 "Failed to list system disk block devices"
		blkid -s UUID "${DEV}" | grep "UUID="
		CHECK_RESULT $? 0 0 "Display system block device UUID failed"
		blkid -s TYPE "${DEV}" | grep "TYPE="
		CHECK_RESULT $? 0 0 "Display system block device TYPE failed"
		blkid -o export "${DEV}" | grep "DEVNAME=${DEV}"
		CHECK_RESULT $? 0 0 "Output system block device failed in export format"
		blkid -s BLOCK_SIZE -s UUID "${DEV}" | grep "BLOCK_SIZE=" | grep "UUID="
		CHECK_RESULT $? 0 0 "Failed to display BLOCK-SIZE and UUID for system block devices"
		blkid --help | grep "blkid --label"
		CHECK_RESULT $? 0 0 "BLKID View Help Command Failed"
	fi
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	DNF_REMOVE
	LOG_INFO "End to restore the test environment."
}

main "$@"
