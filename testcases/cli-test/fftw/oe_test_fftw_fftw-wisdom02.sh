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
# @Desc      :   Test fftw-wisdom
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."

    TMP_DIR="$(mktemp -d -t fftw.XXXXXXXXXXXX)"

    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "fftw"
    echo "(fftw-3.3.8 fftw_wisdom #x4be12fff #x7b2df9b2 #xa5975329 #x385b0041
(fftw_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftw_wisdom

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    fftw-wisdom -n -v 2>&1 | grep -q "system-wisdom"
    CHECK_RESULT $? 1 0 "Check -n failed."
    fftw-wisdom --no-system-wisdom -v 2>&1 | grep -q "system-wisdom"
    CHECK_RESULT $? 1 0 "Check --no-system-wisdom failed."
    fftw-wisdom -w ${TMP_DIR}/fftw_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check -w failed."
    fftw-wisdom -w - < ${TMP_DIR}/fftw_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check -w STDIN failed."    
    fftw-wisdom --wisdom-file ${TMP_DIR}/fftw_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check --wisdom-file failed."
    fftw-wisdom -T 2 cif3x4x5 2>&1 | grep -q "fftw_wisdom"
    CHECK_RESULT $? 0 0 "Check -T failed."
    fftw-wisdom --threads=2 cif3x4x5 2>&1 | grep -q "fftw_wisdom"
    CHECK_RESULT $? 0 0 "Check --threads=N failed."
    fftw-wisdom -m cif3x4x5 2>&1 | grep -q "#x11bdd"
    CHECK_RESULT $? 0 0 "Check -m failed."
    fftw-wisdom --measure cif3x4x5 2>&1 | grep -q "#x11bdd"
    CHECK_RESULT $? 0 0 "Check --measure failed."
    fftw-wisdom -e cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check -e failed."
    fftw-wisdom --estimate cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check --estimate failed."
    fftw-wisdom -x cif3x4x5 2>&1 | grep -q "#x1040"
    CHECK_RESULT $? 0 0 "Check -e failed."
    fftw-wisdom --exhaustive cif3x4x5 2>&1 | grep -q "#x1040"
    CHECK_RESULT $? 0 0 "Check --exhaustive failed."
    
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -rf ${TMP_DIR}
    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"