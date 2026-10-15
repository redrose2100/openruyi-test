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
    g++ -g -o valgrind_test ./common/valgrind_test_01.cpp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    valgrind --tool=cachegrind --cachegrind-out-file=valgrind_test.log ./valgrind_test
    grep "cache" valgrind_test.log 
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cachegrind-out-file error"
    valgrind --tool=cachegrind --cache-sim=yes ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --cache-sim error"
    valgrind --tool=cachegrind --branch-sim=yes ./valgrind_test > valgrind_test.log 2>&1
    grep "Branches:" valgrind_test.log
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --branch-sim error"
    valgrind --tool=cachegrind --cache-sim=yes --I1=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"
    valgrind --tool=cachegrind --cache-sim=yes --I1=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --D1 error"
    valgrind --tool=cachegrind --cache-sim=yes --LL=1024,4,64 ./valgrind_test
    CHECK_RESULT $? 0 0 "execute valgrind --tool=cachegrind --I1 error"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf valgrind_test* cachegrind*
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
