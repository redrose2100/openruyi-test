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
# @Desc      :   Command test valgrind
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "valgrind glibc-devel glibc-debuginfo gcc-c++"
    g++ -g -lpthread -o valgrind_test ./common/valgrind_test_08.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --tool=helgrind --free-is-write=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --free-is-write error"
    valgrind --tool=helgrind --track-lockorders=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --track-lockorders error"
    valgrind --tool=helgrind --history-level=approx ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --history-level error"
    valgrind --tool=helgrind --conflict-cache-size=100000  ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --conflict-cache-size error"
    valgrind --tool=helgrind --check-stack-refs=no  ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --check-stack-refs error"
    valgrind --tool=helgrind --ignore-thread-creation=yes  ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=helgrind --ignore-thread-creation error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
