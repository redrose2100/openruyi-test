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
# @Date      :   2022/07/24
# @License   :   Mulan PSL v2
# @Desc      :   TEST celtenc
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

# Data and parameter configuration that need to be preloaded
function config_params() {
    LOG_INFO "Start to config params of the case."

    CELTENC="celtenc"
    CELTDEC="celtdec"
    # Generate file output name
    TMP_DIR="$(mktemp -d -t celt051.XXXXXXXXXXXX)"
    # Inter file address
    TEST_WAV="test_input/test.wav"
    TEST_ARGS=(
        "--bitrate 20"				# Encoding bit-rate
        "--comp 8"				    # Encoding complexity (0-10)
        "--skeleton"				# outputs ogg skeleton metadata (may cause incompatibilities)
        "--comment comment=AAA"		# Add the given string as an extra comment. This may be used multiple times
        "--author HHH"				# Author of this track
        "--title FFF"				# Title for this track
        "--rate 44100"				# Sampling rate for raw input
        "--mono"				    # Consider raw input as mono
        "--stereo"				    # Consider raw input as stereo
        "--le"					    # Raw input is little-endian
        "--be"					    # Raw input is big-endian
        "--8bit"				    # Raw input is 8-bit unsigned
        "--16bit"				    # Raw input is 16-bit signed
        "-V"					    # Verbose mode (show bit-rate)
    )

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
    LOG_INFO $'celtenc version information :'
    ${CELTENC} -v
    CHECK_RESULT $? 0 0 "command -v error"
    LOG_INFO $'celtenc help information :'
    ${CELTENC} --help
    CHECK_RESULT $? 0 0 "command --help error"

    # Test all commands in TEST_ARGS
    for args in "${TEST_ARGS[@]}"
    do
        LOG_INFO "test case args: ${args}"
        # Change the format of output file name
        OUTPUT="$(echo "${args}" | sed 's/\W/_/g')"
        # Generate file output address
        TMP_PATH="$(mktemp -u -p ${TMP_DIR} -t ${OUTPUT}.XXXXXXXXXXXX)"
        # ${CELTENC} ${args} ${TEST_WAV} test_output_refs/${OUTPUT}.oga 2>&1
        # Start the test
        RESLUT="$(${CELTENC} ${args} ${TEST_WAV} ${TMP_PATH}.oga 2>&1)"
        # -V is displayed on the console
        if [[ ${args} =~ "-V" ]];then
            LOG_INFO $'-V console output\n'"${RESLUT:0:500}"
        fi
        # Judge whether the output file is equal to the expected file
        if [[ ! -f ${TMP_PATH}.oga ]]; then
            # LOG_ERROR "args: ${args} out error"$'\n'"${RESLUT:0:500}"
            CHECK_RESULT 0 0 1 "args: ${args} out error"$'\n'"${RESLUT:0:500}"
        # else
        #     CMP_TMP=$(cmp test_output_refs/${OUTPUT}.oga ${TMP_PATH}.oga)
        #     if [[ $? -ne 0 ]]; then
        #         LOG_WARN ${CMP_TMP}
        #     fi
        fi
    done
    LOG_INFO "all case output :"$'\n'"$(ls -Al ${TMP_DIR})"

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
