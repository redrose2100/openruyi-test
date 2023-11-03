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
# @Desc      :   TEST celtdec
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."
    CELTDEC="celtdec051"
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
    ${CELTDEC} -h | grep "Usage"
    CHECK_RESULT $? 0 0 "option: -h error"
    ${CELTDEC} --help | grep "Usage"
    CHECK_RESULT $? 0 0 "option: --help error"
    ${CELTDEC} -v | grep "CELT.*encoder"
    CHECK_RESULT $? 0 0 "option: -v error"
    ${CELTDEC} --version | grep "CELT.*encoder"
    CHECK_RESULT $? 0 0 "option: --version error"
    # The default is mono
    ${CELTDEC} common/test.oga ${TMP_DIR}/test_1.out 2>&1 | grep "Encoded with CELT" && \
    test -f ${TMP_DIR}/test_1.out 
    CHECK_RESULT $? 0 0 "${CELTDEC} FILEIO error"
    ${CELTDEC} - - < common/test.oga > ${TMP_DIR}/test_2.out 
    test -f ${TMP_DIR}/test_2.out 
    CHECK_RESULT $? 0 0 "${CELTDEC} STDIO error"
    # Treat the raw input as mono
    ${CELTDEC} --mono common/test.oga ${TMP_DIR}/test_3.out 2>&1 | grep "Encoded with CELT" && \
    test -f ${TMP_DIR}/test_3.out 
    CHECK_RESULT $? 0 0 "option: --mono error"
    # Treat the raw input as stereo
    ${CELTDEC} --stereo common/test.oga ${TMP_DIR}/test_4.out 2>&1 | grep "Encoded with CELT" && \
    test -f ${TMP_DIR}/test_4.out 
    CHECK_RESULT $? 0 0 "option: --stereo error"
    # The sampling rate of the raw data
    ${CELTDEC} --rate 12345 common/test.oga ${TMP_DIR}/test_5.out 2>&1 | grep "12345" && \
    test -f ${TMP_DIR}/test_5.out 
    CHECK_RESULT $? 0 0 "option: --rate error"
    # Simulate n random packet drops
    ${CELTDEC} --packet-loss 8 common/test.oga ${TMP_DIR}/test_6.out 2>&1 | grep "Encoded with CELT" && \
    test -f ${TMP_DIR}/test_6.out 
    CHECK_RESULT $? 0 0 "option: --packet-loss error"
    # Verbose mode (show bit-rate)
    ${CELTDEC} -V common/test.oga ${TMP_DIR}/test_7.out 2>&1 | grep "Bitrate in use: 46 bytes/packet" && \
    test -f ${TMP_DIR}/test_7.out 
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
