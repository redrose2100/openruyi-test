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
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    vpxenc --codec=vp8 -w 352 -h 288 --kf-min-dist=2 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'kf_min_dist.*2'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --kf-min-dist "
    vpxenc --codec=vp8 -w 352 -h 288 --kf-max-dist=126 --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'kf_max_dist.*126'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --kf-max-dist "
    vpxenc --codec=vp8 -w 352 -h 288 --disable-kf --threads=6 --verbose -o tmp/1_maxq.ivf data/1.mp4 2>&1 | grep 'kf_min_dist.*0'
    CHECK_RESULT $? 0 0 "Failed option: vpxenc --disable-kf "
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
