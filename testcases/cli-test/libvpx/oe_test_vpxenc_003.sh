#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   310809690@qq.com
# @Date      :   2022/09/19
# @License   :   Mulan PSL v2
# @Desc      :   Test vpxenc of libvpx
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL libvpx
    echo y | yum install ffmpeg 
    tar -zxvf test.tar.gz
    mkdir tmp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --verbose --webm -o tmp/1.webm data/1.mp4 && ls tmp | grep '1.webm'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --webm "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --output-partitions -o tmp/1_P.ivf data/1.mp4 && ls tmp | grep '1_P.ivf'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --output-partitions "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --q-hist=2 -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'Quantizer Selection:'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --q-his "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --rate-hist=2 -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'Rate (over 6000ms window):'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --rate-hist "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --disable-warnings -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'Pass 1/1 frame'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-warnings "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --disable-warning-prompt -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'Pass 1/1 frame'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-warning-prompt "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --test-decode=warn -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'Pass 1/1 frame'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --test-decode "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --verbose --profile=0 -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'g_profile.*0'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --profile "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --fps=30/1 -o tmp/1_P.ivf data/1.mp4 && ffprobe -show_streams -print_format json tmp/1_P.ivf 2>&1 | grep '30 fps'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --fps "
    vpxenc --codec=vp8 -w 352 -h 288 --error-resilient=1 --threads=6 --verbose -o tmp/1_P.ivf data/1.mp4 2>&1 | grep 'g_error_resilient.*1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --error-resilient "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp data
    DNF_REMOVE
    echo y | yum remove ffmpeg 
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
