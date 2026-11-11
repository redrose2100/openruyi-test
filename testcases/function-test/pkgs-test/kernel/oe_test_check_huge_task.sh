#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   检查内核是否打开HUNG TASK相关开关
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

# 内核配置文件在不同发行版/镜像上位置不同：优先 /boot/config-<ver>，
# 退化为 /proc/config.gz（需 IKCONFIG_PROC）。两者都没有时无法测试，直接跳过。
function get_kernel_config() {
    local cfg=/boot/config-$(uname -r)
    if [ -f "${cfg}" ]; then
        grep -w "$1" "${cfg}"
        return $?
    fi
    if [ -f /proc/config.gz ] && command -v zgrep >/dev/null 2>&1; then
        zgrep -w "$1" /proc/config.gz
        return $?
    fi
    LOG_WARN "Neither /boot/config-$(uname -r) nor /proc/config.gz is available."
    return 2
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cfg=/boot/config-$(uname -r)
    if [ ! -f "${cfg}" ] && [ ! -f /proc/config.gz ]; then
        LOG_WARN "Kernel config file is not available, skip the case."
        exit 255
    fi
    LOG_INFO "Finish preparing the test environment."
}

function run_test()
{
    LOG_INFO "Start testing..."
    get_kernel_config CONFIG_DETECT_HUNG_TASK=y
    CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK ERROR"

    get_kernel_config CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
    CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK_TIMEOUT ERROR"

    get_kernel_config CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
    CHECK_RESULT $? 0 1 "BOOTPARAM_HUNG_TASK_PANIC_VALUE ERROR"
    LOG_INFO "Finish test!"
}

main "$@"
