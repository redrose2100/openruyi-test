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
    gcc -o valgrind_test ./common/valgrind_test_07.cpp -pthread
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --tool=drd --show-stack-usage=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-stack-usage error"
    valgrind --tool=drd --ignore-thread-creation=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --ignore-thread-creation error"
    valgrind --tool=drd --ptrace-addr=0x12345678+4 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --ptrace-addr error"
    valgrind --tool=drd --trace-addr=0x12345678 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-addr error"
    valgrind --tool=drd --trace-alloc=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-alloc error"
    valgrind --tool=drd --trace-barrier=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-barrier error"
    valgrind --tool=drd --trace-cond=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-cond error"
    valgrind --tool=drd --trace-fork-join=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-fork-join error"
    valgrind --tool=drd --trace-hb=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-hb error"
    valgrind --tool=drd --trace-mutex=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --trace-mutex error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
