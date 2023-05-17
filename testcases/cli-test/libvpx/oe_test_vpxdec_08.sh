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
    DNF_INSTALL "libvpx tar"
    tar -xf common/libvpx.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    vpxdec --codec=vp8 --verbose --threads=6 --scale -o tmp/scale.vpx data/1.ivf && ls tmp | grep 'scale.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --scale"
    vpxdec --codec=vp8 --verbose --threads=6 --md5 -o tmp/md5.vpx data/1.ivf 2>&1 | grep '.* tmp/md5.vpx'
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --md5"
    vpxdec --codec=vp8  --threads=6 -o tmp/f.vpx data/1.ivf --framestats=tmp/f.vpx 
    CHECK_RESULT $? 0 0 "Failed option: vpxdec --framestats"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
