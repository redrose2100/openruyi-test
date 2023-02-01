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
# @Author    :   songfurong
# @Contact   :   2597578239@qq.com
# @Date      :   2022/09/29
# @License   :   Mulan PSL v2
# @Desc      :   TEST celtenc
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    CELTENC="celtenc051"
    TMP_DIR="$(mkdir -p ./tmp)"
    LOG_INFO "End to config params of the case."
}

# Installation Preparation of test objects, tools required for testing, etc
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "celt051"
    LOG_INFO "End to prepare the test environment."
}

# Execution of test points
function run_test() {
    LOG_INFO "Start to run test."
    #-v/--version; -h/--help
    ${CELTENC} -h | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    ${CELTENC} --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    ${CELTENC} -v | grep "CELT.*encoder"
    CHECK_RESULT $? 0 0 "option: -v error"
    ${CELTENC} --version | grep "CELT.*encoder"
    CHECK_RESULT $? 0 0 "option: --version error"
    ${CELTENC} common/test.wav ${TMP_DIR}/test_0.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_0.out 
    # Encoding bit-rate
    ${CELTENC} --bitrate 20 common/test.wav ${TMP_DIR}/test_1.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_1.out 
    CHECK_RESULT $? 0 0 "option: --bitrate error"
    # Encoding complexity (0-10)
    ${CELTENC} --comp 8 common/test.wav ${TMP_DIR}/test_2.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_2.out 
    CHECK_RESULT $? 0 0 "option: --comp error"
    # outputs ogg skeleton metadata (may cause incompatibilities)
    ${CELTENC} --skeleton common/test.wav ${TMP_DIR}/test_3.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_3.out 
    CHECK_RESULT $? 0 0 "option: -skeleton error"
    # Add the given string as an extra comment. This may be used multiple times
    ${CELTENC} --comment comment=AAA common/test.wav ${TMP_DIR}/test_4.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_4.out 
    CHECK_RESULT $? 0 0 "option: --comment error"
    # Author of this track
    ${CELTENC} --author HHH common/test.wav ${TMP_DIR}/test_5.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_5.out
    CHECK_RESULT $? 0 0 "option: --author error"
    # Title for this track
    ${CELTENC} --title FFF common/test.wav ${TMP_DIR}/test_6.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_6.out 
    CHECK_RESULT $? 0 0 "option: --title error"
    # Sampling rate for raw input
    ${CELTENC} --rate 44100 common/test.wav ${TMP_DIR}/test_7.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_7.out 
    CHECK_RESULT $? 0 0 "option: --rate error"
    # Consider raw input as mono
    ${CELTENC} --mono common/test.wav ${TMP_DIR}/test_8.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_8.out 
    CHECK_RESULT $? 0 0 "option: --mono error"
    # Consider raw input as stereo
    ${CELTENC} --stereo common/test.wav ${TMP_DIR}/test_9.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_9.out 
    CHECK_RESULT $? 0 0 "option: --stereo error"
    # Raw input is little-endian
    ${CELTENC} --le common/test.wav ${TMP_DIR}/test_10.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_10.out 
    CHECK_RESULT $? 0 0 "option: --le error"
    # Raw input is big-endian
    ${CELTENC} --be common/test.wav ${TMP_DIR}/test_11.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_11.out 
    CHECK_RESULT $? 0 0 "option: --be error"
    # Raw input is 8-bit unsigned
    ${CELTENC} --8bit common/test.wav ${TMP_DIR}/test_12.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_12.out 
    CHECK_RESULT $? 0 0 "option: --8bit error"
    # Raw input is 16-bit signed
    ${CELTENC} --16bit common/test.wav ${TMP_DIR}/test_13.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_13.out 
    CHECK_RESULT $? 0 0 "option: --16bit error"
    # Verbose mode (show bit-rate)
    ${CELTENC} -V common/test.wav ${TMP_DIR}/test_14.out 2>&1 | grep "Encoding 44100 Hz audio using mono" && \
    test -f ${TMP_DIR}/test_14.out 
    CHECK_RESULT $? 0 0 "option: -V error"
    LOG_INFO "End to run test."
}

# Post processing to restore the test environment
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
