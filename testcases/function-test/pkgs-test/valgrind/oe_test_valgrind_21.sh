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
# @Date      :   2023/08/27
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
    valgrind --tool=lackey --basic-counts=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --basic-counts=<no|yes> [default: yes] error"
    valgrind --tool=lackey --detailed-counts=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --detailed-counts=<no|yes> [default: no] error"
    valgrind --tool=lackey --trace-mem=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-mem=<no|yes> [default: no] error"
    valgrind --tool=lackey --trace-superblocks=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-superblocks=<no|yes> [default: no] error"
    valgrind --tool=lackey --fnname=func1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --fnname=<name> [default: main] error"
    valgrind --tool=exp-bbv --bb-out-file=bb.out ./valgrind_test && test -e bb.out
    CHECK_RESULT $? 0 0 "execute valgrind --bb-out-file=<name> [default: bb.out.%p] error"
    rm -f bb.out
    valgrind --tool=exp-bbv --pc-out-file=pc.out ./valgrind_test && test -e pc.out
    CHECK_RESULT $? 0 0 "execute valgrind --pc-out-file=<name> [default: pc.out.%p] error"
    rm -f pc.out
    valgrind --tool=exp-bbv --interval-size=50000000 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --interval-size=<number> [default: 100000000] error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test* bb.out.*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
