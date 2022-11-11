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
# @Desc      :   Test fftwl-wisdom
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    TMP_DIR="$(mktemp -d -t fftw.XXXXXXXXXXXX)"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "fftw"
    echo "(fftw-3.3.8 fftwl_wisdom #xc55000ae #xe28b9b3a #x070e76c6 #xeeae5518
(fftwl_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftwl_wisdom
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    fftwl-wisdom -e cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check fftwl-wisdom -e failed."
    fftwl-wisdom --estimate cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check fftwl-wisdom --estimate failed."
    fftwl-wisdom -x cif3x4x5 2>&1 | grep -q "#x1040"
    CHECK_RESULT $? 0 0 "Check fftwl-wisdom -e failed."
    fftwl-wisdom --exhaustive cif3x4x5 2>&1 | grep -q "#x1040"
    CHECK_RESULT $? 0 0 "Check fftwl-wisdom --exhaustive failed."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ${TMP_DIR}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"