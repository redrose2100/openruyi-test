#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   fuyahong
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025-11-19
# @License   :   Mulan PSL v2
# @Desc      :   Test sox audio format support (FLAC, AAC)
# ############################################
#shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "sox flac"
    # Create test audio file if not exists
    if [ ! -f common/input.mp3 ]; then
        # Generate a test tone
        sox -n -r 44100 -c 2 common/input.mp3 synth 30 sine 440
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run format support test."
    # Test 1: MP3 to FLAC conversion
    sox common/input.mp3 output.flac
    CHECK_RESULT $? 0 0 "MP3 to FLAC conversion failed"
    test -e output.flac
    CHECK_RESULT $? 0 0 "output.flac not exist"
    
    # Test 2: FLAC to WAV conversion
    sox output.flac output_from_flac.wav
    CHECK_RESULT $? 0 0 "FLAC to WAV conversion failed"
    test -e output_from_flac.wav
    CHECK_RESULT $? 0 0 "output_from_flac.wav not exist"
    
    # Test 3: MP3 to AAC conversion (if supported)
    if sox common/input.mp3 output.aac 2>/dev/null; then
        CHECK_RESULT 0 0 0 "MP3 to AAC conversion succeeded"
        test -f output.aac
        CHECK_RESULT $? 0 0 "output.aac does not exist"
    
        # Verify AAC format information
        if soxi output.aac 2>/dev/null | grep -q -E "(AAC|M4A)"; then
            CHECK_RESULT 0 0 0 "AAC format verified"
        else
            CHECK_RESULT 1 0 0 "AAC format not detected"
        fi
    else
        LOG_INFO "AAC format not supported in this build"
    fi
    
    # Test 4: Verify format information
    soxi output.flac | grep "FLAC"
    CHECK_RESULT $? 0 0 "FLAC format not detected"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf output.flac output_from_flac.wav output.aac
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
