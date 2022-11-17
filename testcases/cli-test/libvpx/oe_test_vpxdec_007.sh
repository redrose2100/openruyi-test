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
# @Desc      :   Test vpxdec of libvpx
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
    vpxdec --help 2>&1 | grep 'Options:'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --help "
    vpxdec --codec=vp8 --threads=6 --verbose --i420 -o tmp/1.vpx data/1.ivf && ls tmp | grep '1.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --codec"
    vpxdec --codec=vp8 --threads=6 --verbose -o tmp/1_flipuv.i420 data/1.ivf && ls tmp | grep '1_flipuv.i420'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec -o"
    vpxdec --codec=vp8 --threads=6 --verbose --noblit -o tmp/noblit.vpx data/1.ivf 2>&1| grep 'WebM Project VP8 Decoder v1.7.0'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --noblit"
    vpxdec --codec=vp8 --threads=6 --verbose --progress -o tmp/progress.vpx data/1.ivf 2>&1 | grep '74 decoded frames.*74 showed frames'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --progress"
    vpxdec --codec=vp8 --threads=6 --verbose --progress --limit=10 -o tmp/limit.vpx data/1.ivf 2>&1 | grep '10 decoded frames'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --limit"
    vpxdec --codec=vp8 --threads=6 --verbose --progress --skip=10 -o tmp/skip.vpx data/1.ivf 2>&1 | grep 'Skipping first 10 frames'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --skip"
    vpxdec --codec=vp8 --threads=6 --verbose --summary -o tmp/postproc.vpx data/1.ivf 2>&1 | grep '74 decoded frames'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --summary "
    vpxdec --codec=vp8 --threads=6 --verbose -o tmp/threads.vpx data/1.ivf && ls tmp | grep 'threads.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --threads "
    vpxdec --codec=vp8 --threads=6  --verbose -o tmp/verbose.vpx data/1.ivf 2>&1 | grep 'WebM Project VP8 Decoder v1.7.0'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --verbose "
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
