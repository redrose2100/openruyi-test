#!/usr/bin/env bash

# Copyright (c) 2026. Huawei Technologies Co., Ltd. ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liuyafei
# @Contact   :   liuyafei@uniontech.com
# @Date      :   2026/04/24
# @License   :   Mulan PSL v2
# @Desc      :   kernel led-class-flash module test
# #############################################
source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start preparing test environment."
    if [ ! -f "/usr/lib/modules/$(uname -r)/kernel/drivers/leds/led-class-flash.ko.xz" ]; then
        LOG_WARN "led-class-flash module not found, test skipped."
        exit 255
    fi
    LOG_INFO "Environment ready."
}

function run_test() {
    LOG_INFO "Testing led-class-flash module..."
    local kernel_name mod_name
    kernel_name=$(uname -r)
    mod_name=led_class_flash
    
    # 1. 检查模块文件是否存在
    test -f "/usr/lib/modules/${kernel_name}/kernel/drivers/leds/led-class-flash.ko.xz"
    CHECK_RESULT $? 0 0 "Module file missing"
    
    # 2. 加载模块
    modprobe led_class_flash
    CHECK_RESULT $? 0 0 "Load failed"
    
    # 3. 验证模块信息
    modinfo led_class_flash | grep -q -i version
    CHECK_RESULT $? 0 0 "Version info missing"
    
    # 4. 检查加载状态
    lsmod | grep -q led_class_flash
    CHECK_RESULT $? 0 0 "Module not loaded"
    
    # 5. 卸载模块
    if [ "$(modprobe --version 2>/dev/null | awk '/version/{print $3}')" -gt "29" ]; then
        modprobe -r --remove-holders "${mod_name}"
    else
        modprobe -r "${mod_name}"
    fi
    CHECK_RESULT $? 0 0 "Unload failed"
    
    # 6. 验证卸载状态
    ! lsmod | grep -q led_class_flash
    CHECK_RESULT $? 0 0 "Module still loaded"
    
    LOG_INFO "Test completed."
}

function post_test() {
    LOG_INFO "Cleaning up."
    modprobe -r led_class_flash 2>/dev/null
}

main "$@"
