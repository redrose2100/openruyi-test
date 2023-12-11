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
# @Date      :   2023-10-17
# @License   :   Mulan PSL v2
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -lpthread -o valgrind_test ./common/valgrind_test_01.cpp
    g++ -g -o valgrind_test_thread ./common/valgrind_test_08.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    ### The following test case can only be tested using the Valgrind-3.16.0 ###
    valgrind --help-dyn-options | grep "dynamically changeable options"
    CHECK_RESULT $? 0 0 "execute valgrind --help-dyn-options error"
    valgrind --exit-on-first-error=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --exit-on-first-error error"
    valgrind --error-markers="begin_error,end_error" ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --error-markers error"
    valgrind --show-error-list=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --show-error-list error"
    valgrind --progress-interval=1 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --progress-interval error"
    valgrind --keep-debuginfo=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --keep-debuginfo error" 
    valgrind --tool=callgrind --collect-systime=usec ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=callgrind --collect-systime error"
    valgrind --tool=drd --trace-rwlock=yes ./valgrind_test_thread
    CHECK_RESULT $? 0 0 "execute valgrind --trace-rwlock error"
    valgrind --tool=drd --trace-semaphore=yes ./valgrind_test_thread
    CHECK_RESULT $? 0 0 "execute valgrind --trace-semaphore error"
    valgrind --tool=dhat --dhat-out-file=dhat.out ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --dhat-out-file=<file> error"
    valgrind --tool=helgrind --delta-stacktrace=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --delta-stacktrace error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* dhat.out* callgrind.out.*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
