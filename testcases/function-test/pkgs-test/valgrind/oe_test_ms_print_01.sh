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
# @Date      :   2023-10-12
# @License   :   Mulan PSL v2
# @Desc      :   Command test ms_print
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -o valgrind_test ./common/valgrind_test_08.cpp -pthread -lstdc++
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    ### prepare massif.out for testcases ###
    valgrind --tool=massif ./valgrind_test
    CHECK_RESULT $? 0 0 "prepare massif.out file fail"
    ms_print -h > valgrind_test.log 2>&1
    grep "usage: ms_print" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute usage: ms_print -h error"
    ms_print --help valgrind_test.log 2>&1
    grep "usage: ms_print" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute usage: ms_print --help error"
    ms_print --version > valgrind_test.log 2>&1
    grep -E "ms_print-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute ms_print --version error"
    ms_print --threshold=0.5 massif.out* > valgrind_test.log 2>&1
    grep "threshold=0.5" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute ms_print --threshold error"
    ms_print --x=4 massif.out* > valgrind_test.log 2>&1
    grep "x=4" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute ms_print --x error"
    ms_print --y=4 massif.out* > valgrind_test.log 2>&1
    grep "y=4" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute ms_print --y error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test* massif.out*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"