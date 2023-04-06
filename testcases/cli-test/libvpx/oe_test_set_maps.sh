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
    decode_with_drops  data/vp8.ivf  tmp/1.ivf 2-1 2>&1 | grep 'Processed 25 frames.'
    CHECK_RESULT $? 0 0 "Failed option: decode_with_drops"
    set_maps vp8 352 288 data/1.ivf tmp/1.ivf 2>&1 | grep 'Processed 1 frames'
    CHECK_RESULT $? 0 0 "Failed option: set_maps"
    decode_to_md5 data/vp8.ivf  tmp/1.ivf 2>&1 | grep 'Processed 25 frames.'
    CHECK_RESULT $? 0 0 "Failed option: decode_to_md5"
    vp8_simple_decoder data/2.ivf tmp/1.mp4 2>&1 | grep 'Processed 25 frames.'
    CHECK_RESULT $? 0 0 "Failed option: vp8_simple_decoder"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
