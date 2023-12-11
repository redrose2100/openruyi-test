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
# @Desc      :   Command test callgrind_annotate
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
    CHECK_RESULT $? 0 0 "prepare callgrind.out file fail"
    callgrind_annotate -h > valgrind_test.log 2>&1
    grep "usage: callgrind_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate -h error"
    callgrind_annotate --help valgrind_test.log 2>&1
    grep "usage: callgrind_annotate" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --help error"
    callgrind_annotate --version > valgrind_test.log 2>&1
    grep -E "callgrind_annotate-[0-9]+.[0-9]+.[0-9]+" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --version error"
    callgrind_annotate --show=Ir callgrind.out.* > valgrind_test.log 2>&1
    grep "callgrind.out" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute allgrind_annotate --show error"
    callgrind_annotate --sort=Ir callgrind.out.* > valgrind_test.log 2>&1
    grep "callgrind.out" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --sort error"
    callgrind_annotate --threshold=0.2% callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --threshold  error"
    callgrind_annotate --auto=yes callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --auto error"
    callgrind_annotate --context=16 callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --context error" 
    callgrind_annotate --inclusive=yes callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --inclusive error" 
    callgrind_annotate --tree=both callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --tree error" 
    callgrind_annotate -I=dir callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate -I error" 
    callgrind_annotate --include=dir callgrind.out.*
    CHECK_RESULT $? 0 0 "execute callgrind_annotate --include error" 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* callgrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
