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
# @Desc      :   pmdumptext -d test
# #############################################
# shellcheck disable=SC2154,SC2119,SC1091

source "common/common_pcp-gui.sh"

function pre_test() {
	deploy_env
}

function run_test() {
	for cmd in F G H i l m M; do
		pmdumptext -d \. -$cmd -T 5s disk.dev.read
		CHECK_RESULT $?
	done
}

function post_test() {
	DNF_REMOVE
}

main "$@"

