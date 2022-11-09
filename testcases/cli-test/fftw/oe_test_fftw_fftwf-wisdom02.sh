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
# @Desc      :   Test fftwf-wisdom
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
    echo "(fftw-3.3.8 fftwf_wisdom #xca4daf64 #xc8f59ea6 #x586875c9 #x14018994
(fftwf_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftwf_wisdom

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    fftwf-wisdom -n -v 2>&1 | grep -q "system-wisdom"
    CHECK_RESULT $? 1 0 "Check -n failed."
    fftwf-wisdom --no-system-wisdom -v 2>&1 | grep -q "system-wisdom"
    CHECK_RESULT $? 1 0 "Check --no-system-wisdom failed."
    fftwf-wisdom -w ${TMP_DIR}/fftwf_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check -w failed."
    fftwf-wisdom -w - < ${TMP_DIR}/fftwf_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check -w STDIN failed."    
    fftwf-wisdom --wisdom-file ${TMP_DIR}/fftwf_wisdom 2>&1 | grep -q "#x12345"
    CHECK_RESULT $? 0 0 "Check --wisdom-file failed."
    fftwf-wisdom -T 2 cif3x4x5 2>&1 | grep -q "fftwf_wisdom"
    CHECK_RESULT $? 0 0 "Check -T failed."
    fftwf-wisdom --threads=2 cif3x4x5 2>&1 | grep -q "fftwf_wisdom"
    CHECK_RESULT $? 0 0 "Check --threads=N failed."
    fftwf-wisdom -m cif3x4x5 2>&1 | grep -q "#x11bdd"
    CHECK_RESULT $? 0 0 "Check -m failed."
    fftwf-wisdom --measure cif3x4x5 2>&1 | grep -q "#x11bdd"
    CHECK_RESULT $? 0 0 "Check --measure failed."
    fftwf-wisdom -e cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check -e failed."
    fftwf-wisdom --estimate cif3x4x5 2>&1 | grep -q "#x31bff"
    CHECK_RESULT $? 0 0 "Check --estimate failed."
    fftwf-wisdom -x cif3x4x5 2>&1 | grep -q "#x1040"
    CHECK_RESULT $? 0 0 "Check -e failed."
    fftwf-wisdom --exhaustive cif3x4x5 2>&1 | grep -q "#x1040"
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