#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-02-20
#@License       :   Mulan PSL v2
#@Desc          :   the function of gmp
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gmp gmp-devel gcc-c++"
    ls ./main.o && rm -rf ./main.o
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    g++ ./main.cpp -o main.o -lgmpxx -lgmp
    CHECK_RESULT $? 0 0 "compilation of main.cpp is failed"
    ls ./main.o
    CHECK_RESULT $? 0 0 "file main.o is not created"
    ./main.o
    CHECK_RESULT $? 0 0 "The executable program main.o execution has failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ls ./main.o && rm -rf ./main.o
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
