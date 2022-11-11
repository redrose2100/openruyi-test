#!/usr/bin/bash

# Copyright (c) 2022. Lanzhou University of Technology.,Univ.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#          http://license.coscl.org.cn/MulanPSL2
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   DingYaoyao
# @Contact   :   d1005562341@126.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   Test wisdom-to-conf
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="$(mkdir -p ./tmp)"
    echo "(fftw-3.3.8 fftw_wisdom #x4be12fff #x7b2df9b2 #xa5975329 #x385b0041
    (fftw_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
    )" > ${TMP_DIR}/wisdom
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fftw gcc"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fftw-wisdom-to-conf -h | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf -h failed."
    fftw-wisdom-to-conf --help | grep -q "Usage"
    CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf --help failed."
    fftw-wisdom-to-conf -V | grep -q "FFTW version"
    CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf -V failed."
    fftw-wisdom-to-conf --version | grep -q "FFTW version"
    CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf --version failed."
    fftw-wisdom-to-conf < ${TMP_DIR}/wisdom | grep -q "fftw_configure_planner"
    CHECK_RESULT $? 0 0 "Check fftw-wisdom-to-conf output failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"