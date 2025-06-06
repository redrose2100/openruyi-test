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
# @Desc      :   Test vpxdec of libvpx
# #############################################
# shellcheck disable=SC1091

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tar libvpx" 
    tar -xf common/libvpx.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    vp8_simple_encoder vp8 352 288 data/1.mp4 tmp/1.ivf 0 1 25 2>&1 | grep 'Processed 25 frames.'
    CHECK_RESULT $? 0 0 "Failed option: vp8_simple_encoder"
    vp8_twopass_encoder vp8 352 288 data/1.mp4 tmp/1.ivf 20 2>&1 | grep 'Pass 1 complete. Processed 20 frames.'
    CHECK_RESULT $? 0 0 "Failed option: vp8_twopass_encoder"
    vp8cx_set_ref 352 288 data/1.ivf tmp/1.ivf 25 2>&1 | grep 'Processed 1 frames.'
    CHECK_RESULT $? 0 0 "Failed option: vp8cx_set_ref"
    vp9_lossless_encoder 352 288 data/1.ivf tmp/1.ivf | grep 'Processed 1 frames'
    CHECK_RESULT $? 0 0 "Failed option: vp9_lossless_encoder"
    vp9_spatial_svc_encoder -f 10 -w 352 -h 288 -s 0 -sl 2 -t 10/1 -b 20 -k 1 -tl 0 -tlm 0 -th 6 -aq 1 -d 8 -sp 5 -bl 1 data/1.mp4 tmp/1.ivf | grep 'Frame cnt and encoding time/FPS'
    CHECK_RESULT $? 0 0 "Failed option: vp8_simple_decoder"
    vp9cx_set_ref 352 288 data/1.ivf tmp/1.ivf 25 30 | grep 'Processed 1 frames.'
    CHECK_RESULT $? 0 0 "Failed option: vp9cx_set_ref"
    vpx_temporal_svc_encoder data/1.mp4 tmp/1.ivf vp8 352 288 1 1 2 2 1 4 1 0 1 8 2>&1 | grep 'Total number of processed frames'
    CHECK_RESULT $? 0 0 "Failed option: vpx_temporal_svc_encoder"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
