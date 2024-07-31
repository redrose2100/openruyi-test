#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   wangyiqiao
# @Contact   :   wangyiqiao@uniontech.com
# @Date      :   2024-7-30
# @License   :   Mulan PSL v2
# @Desc      :   Adjusting screen resolution, orientation, and multi-screen settings, among other functions.
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    xrandr -q | grep "Screen" 
    CHECK_RESULT $? 0 0 "Screen not found"
    output=$(xrandr | grep "connected" | awk 'NR==1{print $1}')
    xrandr "${output}" | grep "HDMI not found" 
    LOG_INFO "Finsh test!"
}

main "$@"