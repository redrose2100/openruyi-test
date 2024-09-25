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
    # 获取屏幕信息
    LOG_INFO "Start testing..."
    xrandr -q | grep "Screen"
    CHECK_RESULT $? 0 0 "Screen not found"
    # 获取第一个连接的显示器
    output=$(xrandr | grep "connected" | awk 'NR==1{print $1}')
    CHECK_RESULT $? 0 0 "No connected display found"
    # 获取第一个连接的显示器的当前分辨率
    xrandr "${output}" | grep "current" | awk '{print $2}'
    CHECK_RESULT $? 0 0 "Failed to query current resolution of ${output}"
    LOG_INFO "Finsh test!"
}

main "$@"