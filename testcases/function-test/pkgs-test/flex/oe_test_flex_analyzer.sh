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
# @Desc      :   flex test for generate analyzer function
# #############################################
# shellcheck disable=SC2120,SC2119

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
	DNF_INSTALL flex
}

function run_test() {
	flex -h
	CHECK_RESULT $?
	flex -V
	CHECK_RESULT $?
	flex -Ca lex.l
	CHECK_RESULT $?
	flex -Ce lex.l
	CHECK_RESULT $?
	flex -Cf lex.l
	CHECK_RESULT $?
	flex -Cm lex.l
	CHECK_RESULT $?
	flex -Cr lex.l
	CHECK_RESULT $?
	flex -Cem lex.l
	CHECK_RESULT $?
}

function post_test() {
	rm -rf lex.yy.c
	DNF_REMOVE
}

main "$@"

