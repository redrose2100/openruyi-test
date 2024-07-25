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
# @Author    :   honghua
# @Contact   :   honghua@iscas.ac.cn
# @Date      :   2024/07/24
# @License   :   Mulan PSL v2
# @Desc      :   Compiler dejagnu
# ############################################
# shellcheck disable=SC2034,SC2154,SC1091
source "$OET_PATH"/libs/locallibs/common_lib.sh

function config_params(){
    L0G_INFO "Start to config params of the case."
    EXECUTE_T="2880m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "dejagnu git gcc gcc-g++ gcc-gfortran"
    git clone https://gitee.com/openeuler/gcc.git
    sleep 3
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cd gcc/testsuite/ || exit 255
    runtest --tool gcc
    CHECK_RESULT 0 0 0 "failed to run gcc testsuite."
    cat gcc.sum
    cat gcc.log
    runtest --tool g++
    CHECK_RESULT 0 0 0 "failed to run g++ testsuite."
    cat g++.sum
    cat g++.log
    runtest --tool gfortran
    CHECK_RESULT 0 0 0 "failed to run gfortran testsuite."
    cat gfortran.sum
    cat gfortran.log
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf gcc
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"