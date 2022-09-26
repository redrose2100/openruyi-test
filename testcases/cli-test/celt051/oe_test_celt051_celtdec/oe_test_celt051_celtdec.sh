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
# @Desc      :   TEST celtdec
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
    TEST_OGA="test_input/test.oga"
    TEST_ARGS=(
        "--mono"			# Force decoding in mono
        "--stereo"			# Force decoding in stereo
        "--rate 44100"		# Force decoding at sampling rate n Hz
        "--packet-loss 8"	# Simulate n % random packet loss
        "-V"				# Verbose mode (show bit-rate)
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
    LOG_INFO $'celtdec version information :'
    ${CELTDEC} -v
    CHECK_RESULT $? 0 0 "command -v error"
    LOG_INFO $'celtdec help information :'
    ${CELTDEC} --help
    CHECK_RESULT $? 0 0 "command --help error"

    # Test all commands in TEST_ARGS
    for args in "${TEST_ARGS[@]}"
    do
        LOG_INFO "test case args: ${args}"
        # Change the format of output file name
        OUTPUT="$(echo "${args}" | sed 's/\W/_/g')"
        # Generate file output address
        TMP_PATH="$(mktemp -u -p ${TMP_DIR} -t ${OUTPUT}.XXXXXXXXXXXX)"
        # ${CELTDEC} ${args} ${TEST_OGA} test_output_refs/${OUTPUT}.wav 2>&1
        # Start the test
        RESLUT="$(${CELTDEC} ${args} ${TEST_OGA} ${TMP_PATH}.wav 2>&1)"
        # -V is displayed on the console
        if [[ ${args} =~ "-V" ]];then
            LOG_INFO $'-V console output\n'"${RESLUT:0:500}"
        fi
        # Judge whether the output file is equal to the expected file
        if [[ ! -f ${TMP_PATH}.wav ]]; then
            CHECK_RESULT 0 0 1 "args: ${args} out error"$'\n'"${RESLUT:0:500}"
        else
            CMP_TMP=$(cmp test_output_refs/${OUTPUT}.wav ${TMP_PATH}.wav)
            if [[ $? -ne 0 ]]; then
                LOG_WARN ${CMP_TMP}
            fi
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
