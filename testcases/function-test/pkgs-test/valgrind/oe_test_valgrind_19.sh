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
    gcc -o valgrind_test_thread ./common/valgrind_test_08.cpp -pthread
    LOG_INFO "End to prepare the test environment"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --tool=massif --heap=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --heap=no|yes error"
    valgrind --tool=massif --heap-admin=6 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --heap-admin=<size> error"
    valgrind --tool=massif --stacks=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --stacks=no|yes error"
    valgrind --tool=massif --pages-as-heap=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --pages-as-heap=no|yes error"
    valgrind --tool=massif --depth=10 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --depth=<number> error"
    valgrind --tool=massif --alloc-fn=func1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --alloc-fn=<name> error"
    valgrind --tool=massif --ignore-fn=func1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --ignore-fn=<name> error"
    valgrind --tool=massif --threshold=0.5 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind ---threshold=<m.n> error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test* massif.out*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
