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
# @Date      :   2023/11/26
# @License   :   Mulan PSL v2
# @Desc      :   pmdumptext -A -T test
# #############################################
# shellcheck disable=SC2154,SC2119,SC1091

source "common/common_pcp-gui.sh"

function pre_test() {
	deploy_env
}

function run_test() {
	pmdumptext --version
	CHECK_RESULT $?
	pmdumptext -A 20min -T 10s -t 2s -a "$archive_data" disk.dev.write
	CHECK_RESULT $?
	pmdumptext -a "$archive_data" -S "@$(date -d "-2 minute" +%H:%M)" -T "@$(date -d "-1 minute" +%H:%M)" disk.dev.read
	CHECK_RESULT $?
	pmdumptext -a "$archive_data" -O "@$(date -d "-2 minute" +%H:%M)" -T "@$(date -d "-1 minute" +%H:%M)" disk.dev.read
	CHECK_RESULT $?
	pmdumptext -T 10s -s 4 -Z UTF-8 -n /var/lib/pcp/pmns/root vfs.inodes.count
	CHECK_RESULT $?
	pmdumptext -imu -h localhost -f '%H:%M:%S' mem.util -s 4
	CHECK_RESULT $?
}

function post_test() {
	DNF_REMOVE
}

main "$@"

