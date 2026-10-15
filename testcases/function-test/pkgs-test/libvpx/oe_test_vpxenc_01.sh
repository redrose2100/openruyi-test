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
    vpxenc --help 2>&1 | grep 'Use --codec to switch to a non-default encoder.'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --help "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1.vpx data/akiyo_qcif.yuv && ls tmp 2>&1 | grep 'akiyo1.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -D "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_o.vpx data/1.mp4 && ls tmp 2>&1 | grep 'akiyo1_o.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -o "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_w.vpx data/1.mp4 2>&1 | grep 'g_w.*352'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -w "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_h.vpx data/1.mp4 2>&1 | grep 'g_h.*288'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -h "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_t.vpx data/1.mp4 2>&1 | grep 'g_threads.*6'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -t "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 --usage=0 -o tmp/akiyo1_u.vpx data/1.mp4 2>&1 | grep 'g_usage.*0'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc -u "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6 -o tmp/akiyo1_i420.vpx data/1.mp4 --i420 2>&1 | grep 'Source file: data/1.mp4 File Type: RAW Format: I420'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --i420 "
    vpxenc --codec=vp8 -w 352 -h 288 --verbose --threads=6  --stereo-mode=mono -o tmp/akiyo1_s.vpx data/1.mp4 && ls tmp 2>&1 | grep 'akiyo1_s.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --stereo-mode "
    vpxenc --codec=vp8 -w 352 -h 288 --threads=6 --verbose --ivf -o tmp/1.ivf data/1.mp4 && ls tmp | grep '1.ivf'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --ivf "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
