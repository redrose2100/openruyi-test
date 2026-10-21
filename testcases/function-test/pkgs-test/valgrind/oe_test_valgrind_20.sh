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
# @Author    :   cuikeyu
# @Contact   :   cky2536184321@163.com
# @Date      :   2023/08/25
# @License   :   Mulan PSL v2
# @Desc      :   Test valgrind
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
    valgrind --tool=massif --peak-inaccuracy=0.5 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --peak-inaccuracy=<m.n> error"
    valgrind --tool=massif --time-unit=i ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --time-unit=i|ms|B error"
    valgrind --tool=massif --detailed-freq=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --detailed-freq=<N> error"
    valgrind --tool=massif --max-snapshots=10 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --max-snapshots=<N> error"
    valgrind --tool=massif --massif-out-file=massif.out ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --massif-out-file=<file> error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test* massif.out*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
