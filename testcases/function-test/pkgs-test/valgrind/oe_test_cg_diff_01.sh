#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   jiangchenyang
# @Contact   :   jiangcy1129@163.com
# @Date      :   2023-08-29
# @License   :   Mulan PSL v2
# @Desc      :   Command test cg_diff
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -o valgrind_test ./common/valgrind_test_01.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ### prepare cachegrind.out for testcase ###
    valgrind --tool=cachegrind ./valgrind_test
    CHECK_RESULT $? 0 0 "prepare cachegrind.out file fail"
    cg_diff -h > valgrind_test.log 2>&1
    grep "usage: cg_diff" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff -h error"
    cg_diff --help > valgrind_test.log 2>&1
    grep "usage: cg_diff" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff --help error"
    if cg_diff -v;then
        cg_diff -v 2>&1 | grep -E "cg_diff-[0-9]+.[0-9]+.[0-9]+"
        CHECK_RESULT $? 0 0 "execute cg_diff -v error"
    fi
    cg_diff --version > valgrind_test.log 2>&1
    grep -E "cg_diff-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute cg_diff --version error"
    cg_diff --mod-filename='s/prog[0-9]/projN/' cachegrind.out.* cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute cg_diff --mod-filename error"
    cg_diff --mod-funcname='s/prog[0-9]/projN/' cachegrind.out.* cachegrind.out.*
    CHECK_RESULT $? 0 0 "execute cg_diff --mod-funcname error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* cachegrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
