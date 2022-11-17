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
    tar -zxvf test.tar.gz
    mkdir tmp
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --target-bitrate=1 -o tmp/akiyo1_tb.vpx data/1.mp4 2>&1 | grep 'rc_target_bitrate.*1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --target-bitrate "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --timebase=1/1000 -o tmp/akiyo1_tb.vpx data/1.mp4 2>&1 | grep 'g_timebase.num.*1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --timebase "
    vpxenc --codec=vp8 -w 352 -h 288 --passes=2 --verbose --threads=6 -o tmp/akiyo1_passes.vpx data/1.mp4 2>&1 | grep 'Pass 2/2 frame'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --passes "
    vpxenc --codec=vp8 -w 352 -h 288 --passes=2 --fpf=tmp/file1 --verbose --threads=6 -o tmp/akiyo1_fpf.vpx data/1.mp4 && ls tmp 2>&1 | grep 'file1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --fpf "
    vpxenc --codec=vp8 -w 352 -h 288 --limit=10 --verbose --threads=6 -o tmp/akiyo1_limit.vpx data/1.mp4 2>&1 | grep '10\/10'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --limit "
    vpxenc --codec=vp8 -w 352 -h 288 --skip=10 --verbose --threads=6 -o tmp/akiyo1_skip.vpx data/1.mp4 2>&1 | grep '74\/64'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --skip "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --good -o tmp/akiyo1_deadline.vpx data/1.mp4 2>&1 | grep '164896B'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --deadline "
    ! vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --quiet -o tmp/akiyo1_deadline.vpx data/1.mp4 2>&1 | grep 'Pass '
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --quiet "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_deadline.vpx data/1.mp4 2>&1 | grep 'Encoder parameters:'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --verbose"
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --psnr -o tmp/akiyo1_deadline.vpx data/1.mp4 2>&1 | grep 'PSNR'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --psnr "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
