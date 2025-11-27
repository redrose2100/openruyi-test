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
# @Author    :   fuyh2020
# @Contact   :   fuyahong@uniontech.com
# @Date      :   2025-11-19
# @License   :   Mulan PSL v2
# @Desc      :   Test sox audio effects (equalization, normalization, etc.)
# ############################################
#shellcheck disable=SC2119
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "sox"
    # Create test audio file if not exists
    if [ ! -f common/input.mp3 ]; then
        sox -n -r 44100 -c 2 common/input.mp3 synth 30 sine 440
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run audio effects test."
    # Test 1: Audio normalization
    sox common/input.mp3 output_normalized.wav norm -3
    CHECK_RESULT $? 0 0 "Audio normalization failed"
    test -e output_normalized.wav
    CHECK_RESULT $? 0 0 "output_normalized.wav not exist"
    
    # Test 2: Bass boost
    sox common/input.mp3 output_bass.wav bass +6
    CHECK_RESULT $? 0 0 "Bass boost failed"
    test -e output_bass.wav
    CHECK_RESULT $? 0 0 "output_bass.wav not exist"
    
    # Test 3: Treble boost
    sox common/input.mp3 output_treble.wav treble +6
    CHECK_RESULT $? 0 0 "Treble boost failed"
    test -e output_treble.wav
    CHECK_RESULT $? 0 0 "output_treble.wav not exist"
    
    # Test 4: High pass filter
    sox common/input.mp3 output_highpass.wav highpass 1000
    CHECK_RESULT $? 0 0 "High pass filter failed"
    test -e output_highpass.wav
    CHECK_RESULT $? 0 0 "output_highpass.wav not exist"
    
    # Test 5: Low pass filter
    sox common/input.mp3 output_lowpass.wav lowpass 500
    CHECK_RESULT $? 0 0 "Low pass filter failed"
    test -e output_lowpass.wav
    CHECK_RESULT $? 0 0 "output_lowpass.wav not exist"
    
    # Test 6: Echo effect
    sox common/input.mp3 output_echo.wav echo 0.8 0.9 50 0.3
    CHECK_RESULT $? 0 0 "Echo effect failed"
    test -e output_echo.wav
    CHECK_RESULT $? 0 0 "output_echo.wav not exist"
    
    # Test 7: Reverb effect
    sox common/input.mp3 output_reverb.wav reverb 50 50 100 100 0 0
    CHECK_RESULT $? 0 0 "Reverb effect failed"
    test -e output_reverb.wav
    CHECK_RESULT $? 0 0 "output_reverb.wav not exist"
    
    # Test 8: Pitch shift
    sox common/input.mp3 output_pitch.wav pitch 200
    CHECK_RESULT $? 0 0 "Pitch shift failed"
    test -e output_pitch.wav
    CHECK_RESULT $? 0 0 "output_pitch.wav not exist"
    
    # Test 9: Tempo change (independent of speed)
    sox common/input.mp3 output_tempo.wav tempo 1.5
    CHECK_RESULT $? 0 0 "Tempo change failed"
    test -e output_tempo.wav
    CHECK_RESULT $? 0 0 "output_tempo.wav not exist"
    
    # Test 10: Multiple effects chain
    sox common/input.mp3 output_chain.wav norm -3 bass +3 treble +2 echo 0.5 0.5 30 0.2
    CHECK_RESULT $? 0 0 "Multiple effects chain failed"
    test -e output_chain.wav
    CHECK_RESULT $? 0 0 "output_chain.wav not exist"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    rm -rf output_*.wav
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
