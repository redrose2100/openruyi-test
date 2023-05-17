#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/03/19
# @License   :   Mulan PSL v2
# @Desc      :   Test vpxenc of libvpx
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libvpx tar"
    tar -xf common/libvpx.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    vpxenc --codec=vp8 -w 352 -h 288 --test-16bit-internal --threads=6 --verbose -o tmp/1_t16.ivf data/1.mp4 && ls tmp | grep '1_t16.ivf'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --test-16bit-internal "
    vpxenc --codec=vp8 -w 352 -h 288 --lag-in-frames=2 --threads=6 --verbose -o tmp/1_lf.ivf data/1.mp4 2>&1 | grep 'g_lag_in_frames.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --lag-in-frames "
    vpxenc --codec=vp8 -w 352 -h 288 --drop-frame=2 --threads=6 --verbose -o tmp/1_df.ivf data/1.mp4 2>&1 | grep 'rc_dropframe_thresh.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --drop-frame "
    vpxenc --codec=vp8 -w 352 -h 288 --resize-allowed=1 --threads=6 --verbose -o tmp/1_ra.ivf data/1.mp4 2>&1 | grep 'rc_resize_allowed.*1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-allowed "
    vpxenc --codec=vp8 -w 352 -h 288 --resize-width=2 --threads=6 --verbose -o tmp/1_rw.ivf data/1.mp4 2>&1 | grep 'rc_scaled_width.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-width "
    vpxenc --codec=vp8 -w 352 -h 288 --resize-height=2 --threads=6 --verbose -o tmp/1_rh.ivf data/1.mp4 2>&1 | grep 'rc_scaled_height.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-height "
    vpxenc --codec=vp8 -w 352 -h 288 --resize-up=2 --threads=6 --verbose -o tmp/1_ru.ivf data/1.mp4 2>&1 | grep 'rc_resize_up_thresh.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-up "
    vpxenc --codec=vp8 -w 352 -h 288 --resize-down=2 --threads=6 --verbose -o tmp/1_rd.ivf data/1.mp4 2>&1 | grep 'rc_resize_down_thresh.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --resize-down "
    vpxenc --codec=vp8 -w 352 -h 288 --end-usage=1 --threads=6 --verbose -o tmp/1_eu.ivf data/1.mp4 2>&1 | grep 'rc_end_usage.*1'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --end-usage "
    vpxenc --codec=vp8 -w 352 -h 288 --min-q=3 --threads=6 --verbose -o tmp/1_minq.ivf data/1.mp4 2>&1 | grep 'rc_min_quantizer.*3'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --min-q "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
