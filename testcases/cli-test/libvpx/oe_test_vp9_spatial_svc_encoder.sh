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
    vp9_spatial_svc_encoder -f 10 -w 352 -h 288 -s 0 -sl 2 -t 10/1 -b 20 -k 1 -r 1 -p 1 -tl 0 -tlm 0 -th 6 -aq 1 -d 8 -sp 5 -bl 1 data/1.mp4 tmp/1.ivf | grep 'Frame cnt and encoding time/FPS'
    CHECK_RESULT $? 0 0 "Failed option: vp8_simple_decoder"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf tmp data
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
