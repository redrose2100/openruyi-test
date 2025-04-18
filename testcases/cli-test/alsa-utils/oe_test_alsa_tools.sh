#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yanglang
# @Contact   :   yanglang@uniontech.com
# @Date      :   2024-3-25
# @License   :   Mulan PSL v2
# @Desc      :   Test alsa-tools
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    if ! lspci | grep -i audio; then
        LOG_INFO "No audio device available, the environment does not support testing"
        exit 255
    else
        DNF_INSTALL "alsa-tools alsa-utils pulseaudio"
        pulseaudio --daemonize --system
    fi
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "start to run test."
    aplay -L | grep "CARD"
    CHECK_RESULT $? 0 0 "aplay -L is failed!"
    arecord -l | grep "card 0"
    CHECK_RESULT $? 0 0 "arecord -L is failed!"
    amixer set Master 50% | grep "50%"
    CHECK_RESULT $? 0 0 "amixer is failed!"
    arecord -d 5 test.wav
    CHECK_RESULT $? 0 0 "arecord is failed!"
    aplay -d 5 test.wav
    CHECK_RESULT $? 0 0 "aplay is failed"
    speaker-test -l 1 -c2 -t test.wav
    CHECK_RESULT $? 0 0 "speaker-test is failed"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.wav
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
