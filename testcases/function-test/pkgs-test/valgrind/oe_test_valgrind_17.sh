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
    valgrind --tool=drd --check-stack-var=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --check-stack-var error"
    valgrind --tool=drd --exclusive-threshold=5 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --exclusive-threshold error"
    valgrind --tool=drd --first-race-only=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --first-race-only error"
    valgrind --tool=drd --free-is-write=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --free-is-write error"
    valgrind --tool=drd --join-list-vol=1 ./valgrind_test 
    CHECK_RESULT $? 0 0 "execute valgrind --join-list-vol error"
    valgrind --tool=drd --report-signal-unlocked=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --report-signal-unlocked error"
    valgrind --tool=drd --segment-merging=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --segment-merging error"
    valgrind --tool=drd --segment-merging-interval=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --segment-merging-interval error"
    valgrind --tool=drd --shared-threshold=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --shared-threshold error"
    valgrind --tool=drd --show-confl-seg=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-confl-seg error"
    LOG_INFO "End to run test."
}   

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
