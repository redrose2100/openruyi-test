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
# @Desc      :   Command test callgrind_control
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
    ### prepare callgrind.out for testcase  ###
    valgrind --tool=callgrind ./valgrind_test
    CHECK_RESULT $? 0 0 "prepare callgrind.out.* file fail"
    callgrind_control -h > valgrind_test.log 2>&1
    grep "Usage: callgrind_control" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control -h error"
    callgrind_control --help valgrind_test.log 2>&1
    grep "Usage: callgrind_control" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control --help error"
    callgrind_control --version > valgrind_test.log 2>&1
    grep -E "callgrind_control-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_control --version error"
    callgrind_control -s callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -s error"
    callgrind_control --stat callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --stat error"
    callgrind_control -b callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -b error"
    callgrind_control --back callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --back error"
    callgrind_control -e callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -e error"
    callgrind_control --dump callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --dump error"
    callgrind_control -z callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -z error"
    callgrind_control --zero callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --zero error"
    callgrind_control -k callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control -k error"
    callgrind_control --kill callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --kill error"
    callgrind_control -i=on callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --instr=on error"
    callgrind_control --instr=on callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --instr=on error"
    callgrind_control --vgdb-prefix=/tmo/prefix callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_control --vgdb-prefix error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* callgrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
