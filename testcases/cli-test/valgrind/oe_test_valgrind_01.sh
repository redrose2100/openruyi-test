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
# @Date      :   2023-08-10
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
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
    valgrind -h | grep "usage: valgrind"
    CHECK_RESULT $? 0 0 "execute valgrind -h error"
    valgrind --help | grep "usage: valgrind"
    CHECK_RESULT $? 0 0 "execute valgrind -help error"
    valgrind --help-debug | grep "debugging options"
    CHECK_RESULT $? 0 0 "execute valgrind --help-debug error"
    valgrind_version=$(rpm -qa valgrind | awk -F '-' '{print $2}')
    test "$(valgrind --version | awk -F'-' '{print $2}')" == "$valgrind_version"
    CHECK_RESULT $? 0 0 "execute valgrind --version error"
    valgrind --tool=memcheck ./valgrind_test > valgrind_test.log 2>&1
    grep "HEAP SUMMARY" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --tool error"
    valgrind --leak-check=full ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --leak-check error"
    valgrind --leak-resolution=low ./valgrind_test > valgrind_test.log 2>&1
    grep "HEAP SUMMARY" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --leak-resolution error"
    valgrind --leak-check=full --show-leak-kinds=none  ./valgrind_test > valgrind_test.log 2>&1
    grep "Reachable blocks (those to which a pointer was found) are not shown" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --show-leak-kinds error"
    valgrind --leak-check=full --errors-for-leak-kinds=none  ./valgrind_test > valgrind_test.log 2>&1
    grep "ERROR SUMMARY: 0 errors from 0 contexts" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --errors-for-leak-kinds error"
    valgrind --leak-check=full --leak-check-heuristics=stdstring  ./valgrind_test > valgrind_test.log 2>&1
    grep "ERROR SUMMARY: 3 errors from 3 contexts" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --leak-check-heuristics error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
