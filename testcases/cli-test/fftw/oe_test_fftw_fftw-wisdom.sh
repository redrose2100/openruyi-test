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
    TYPE="fftw fftwf fftwl"
    echo "(fftw-3.3.8 fftw_wisdom #x4be12fff #x7b2df9b2 #xa5975329 #x385b0041
(fftw_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftw_wisdom
    echo "(fftw-3.3.8 fftwf_wisdom #xca4daf64 #xc8f59ea6 #x586875c9 #x14018994
(fftwf_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftwf_wisdom
    echo "(fftw-3.3.8 fftwl_wisdom #xc55000ae #xe28b9b3a #x070e76c6 #xeeae5518
(fftwl_codelet_n1_16 0 #x12345 #x22222 #x0 #x4396230b #x936694df #xa8dfdff3 #x77777777)
)" > ${TMP_DIR}/fftwl_wisdom

    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "fftw"

    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."

    for FFTW in ${TYPE}
    do
        ${FFTW}-wisdom -h 2>&1 | grep -q "Usage"
        CHECK_RESULT $? 0 0 "${FFTW} option: -h error"
        ${FFTW}-wisdom --help 2>&1 | grep -q "Usage"
        CHECK_RESULT $? 0 0 "${FFTW} option: --help error"
        ${FFTW}-wisdom -V 2>&1 | grep -q "version"
        CHECK_RESULT $? 0 0 "${FFTW} option: -V error"
        ${FFTW}-wisdom --version 2>&1 | grep -q "version"
        CHECK_RESULT $? 0 0 "${FFTW} option: --version error"
        ${FFTW}-wisdom cif3x4x5 2>&1 | grep -q "${FFTW}_wisdom"
        CHECK_RESULT $? 0 0 "${FFTW}-wisdom output error"
        ${FFTW}-wisdom -v cif3x4x5 2>&1 | grep -q "Planning transform"
        CHECK_RESULT $? 0 0 "${FFTW} option: -v error"
        ${FFTW}-wisdom --verbose cif3x4x5 2>&1 | grep -q "Planning transform"
        CHECK_RESULT $? 0 0 "${FFTW} option: --verbose error"
        ${FFTW}-wisdom -t "1e-18" -c 2>&1 | grep -q "${FFTW}_wisdom"
        CHECK_RESULT $? 0 0 "${FFTW} option: -c error"
        ${FFTW}-wisdom -t "1e-18" --canonical 2>&1 | grep -q "${FFTW}_wisdom"
        CHECK_RESULT $? 0 0 "${FFTW} option: --canonical error"
        ${FFTW}-wisdom -v -t "1e-18" -c 2>&1 | grep -q "TIME LIMIT"
        CHECK_RESULT $? 0 0 "${FFTW} option: -t error"
        ${FFTW}-wisdom -v --time-limit="1e-18" --canonical 2>&1 | grep -q "TIME LIMIT"
        CHECK_RESULT $? 0 0 "${FFTW} option: --time-limit=<h> error"
        ${FFTW}-wisdom -o ${TMP_DIR}/test_1_${FFTW}.out cif3x4x5
        grep -q "${FFTW}_wisdom" < ${TMP_DIR}/test_1_${FFTW}.out
        CHECK_RESULT $? 0 0 "${FFTW} option: -o error"
        ${FFTW}-wisdom --output-file=${TMP_DIR}/test_2_${FFTW}.out cif3x4x5
        grep -q "${FFTW}_wisdom" < ${TMP_DIR}/test_2_${FFTW}.out
        CHECK_RESULT $? 0 0 "${FFTW} option: --output-file=FILE error"
        ${FFTW}-wisdom -n -v 2>&1 | grep -q "system-wisdom"
        CHECK_RESULT $? 1 0 "${FFTW} option: -n error"
        ${FFTW}-wisdom --no-system-wisdom -v 2>&1 | grep -q "system-wisdom"
        CHECK_RESULT $? 1 0 "${FFTW} option: --no-system-wisdom error"
        ${FFTW}-wisdom -w ${TMP_DIR}/${FFTW}_wisdom 2>&1 | grep -q "#x12345"
        CHECK_RESULT $? 0 0 "${FFTW} option: -w error"
        ${FFTW}-wisdom -w - < ${TMP_DIR}/${FFTW}_wisdom 2>&1 | grep -q "#x12345"
        CHECK_RESULT $? 0 0 "${FFTW} option: -w STDIN error"    
        ${FFTW}-wisdom --wisdom-file ${TMP_DIR}/${FFTW}_wisdom 2>&1 | grep -q "#x12345"
        CHECK_RESULT $? 0 0 "${FFTW} option: --wisdom-file error"
        ${FFTW}-wisdom -T 2 cif3x4x5 2>&1 | grep -q "${FFTW}_wisdom"
        CHECK_RESULT $? 0 0 "${FFTW} option: -T error"
        ${FFTW}-wisdom --threads=2 cif3x4x5 2>&1 | grep -q "${FFTW}_wisdom"
        CHECK_RESULT $? 0 0 "${FFTW} option: --threads=N error"
        ${FFTW}-wisdom -m cif3x4x5 2>&1 | grep -q "#x11bdd"
        CHECK_RESULT $? 0 0 "${FFTW} option: -m error"
        ${FFTW}-wisdom --measure cif3x4x5 2>&1 | grep -q "#x11bdd"
        CHECK_RESULT $? 0 0 "${FFTW} option: --measure error"
        ${FFTW}-wisdom -e cif3x4x5 2>&1 | grep -q "#x31bff"
        CHECK_RESULT $? 0 0 "${FFTW} option: -e error"
        ${FFTW}-wisdom --estimate cif3x4x5 2>&1 | grep -q "#x31bff"
        CHECK_RESULT $? 0 0 "${FFTW} option: --estimate error"
        ${FFTW}-wisdom -x cif3x4x5 2>&1 | grep -q "#x1040"
        CHECK_RESULT $? 0 0 "${FFTW} option: -e error"
        ${FFTW}-wisdom --exhaustive cif3x4x5 2>&1 | grep -q "#x1040"
        CHECK_RESULT $? 0 0 "${FFTW} option: --exhaustive error"
    done
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