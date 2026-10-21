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
    vpxenc --codec=vp8 -w 352 -h 288 --max-q=62 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_max_quantizer.*62'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --max-q "
    vpxenc --codec=vp8 -w 352 -h 288 --undershoot-pct=10 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_undershoot_pct.*10'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --undershoot-pct "
    vpxenc --codec=vp8 -w 352 -h 288 --overshoot-pct=30 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'overshoot.*30'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --overshoot-pct "
    vpxenc --codec=vp8 -w 352 -h 288 --buf-sz=3000 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_buf_sz.*3000'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-sz "
    vpxenc --codec=vp8 -w 352 -h 288 --buf-initial-sz=3000 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_buf_initial_sz.*3000'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-initial-sz "
    vpxenc --codec=vp8 -w 352 -h 288 --buf-optimal-sz=3000 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_buf_optimal_sz.*3000'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --buf-optimal-sz "
    vpxenc --codec=vp8 -w 352 -h 288 --bias-pct=20 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_2pass_vbr_bias_pct.*20'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --bias-pct "
    vpxenc --codec=vp8 -w 352 -h 288 --minsection-pct=20 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_2pass_vbr_minsection_pct.*20'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --minsection-pct "
    vpxenc --codec=vp8 -w 352 -h 288 --maxsection-pct=80 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_2pass_vbr_maxsection_pct.*80'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --maxsection-pct "
    vpxenc --codec=vp8 -w 352 -h 288 --corpus-complexity=10 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'rc_2pass_vbr_corpus_complexity.*10'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --corpus-complexity "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
