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
# @Date      :   2023-08-20
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
    valgrind  --smc-check=all ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --smc-check error"
    valgrind --read-inline-info=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --read-inline-info error"
    valgrind --read-var-info=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --read-var-info error"
    valgrind --vgdb-poll=1000 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-poll error"
    valgrind --vgdb-shadow-registers=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-shadow-registers error"
    valgrind --vgdb-prefix=/tmp/prefix ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --vgdb-prefix error"
    valgrind --run-libc-freeres=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --run-libc-freeres error"
    valgrind --run-cxx-freeres=no ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --run-cxx-freeres error"
    valgrind --sim-hints=lax-ioctls,fuse-compatible ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --sim-hints error"
    valgrind --fair-sched=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --fair-sched error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
