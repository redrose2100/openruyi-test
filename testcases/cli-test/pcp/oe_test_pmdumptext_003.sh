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
# @Desc      :   pmdumptext -N -P -R -U test
# #############################################
# shellcheck disable=SC2154,SC2119,SC1091

source "common/common_pcp-gui.sh"

function pre_test() {
	deploy_env
}

function run_test() {
	for cmd in N o "P 3" "R 3" r "U STR" u "w 8" X; do
		pmdumptext -"$cmd" -T 5s disk.dev.read
		CHECK_RESULT $?
	done
}

function post_test() {
	DNF_REMOVE
}

main "$@"

