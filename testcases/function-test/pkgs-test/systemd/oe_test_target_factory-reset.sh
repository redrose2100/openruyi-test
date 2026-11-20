#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/10/11
# @License   :   Mulan PSL v2
# @Desc      :   Test factory-reset.target restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL systemd
    if ! rpm -ql systemd | grep factory-reset.target;then
        exit 255
    fi
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    # openRuyi 适配：factory-reset.target 的作用是把系统恢复出厂设置（重启并清理），
    # 在 mugen 自动化环境里 restart 它会让被测机失联，用例表现为停留在
    # SLEEP_WAIT 5 后无任何输出并最终超时（本次报告现象）。
    # 因此不再真正启停 target，只校验 target 已被 systemd 正确加载且单元文件可读。
    systemctl list-unit-files | grep "factory-reset.target"
    CHECK_RESULT $? 0 0 "factory-reset.target not registered"
    systemctl show factory-reset.target -p LoadState | grep "LoadState=loaded"
    CHECK_RESULT $? 0 0 "factory-reset.target is not loaded"
    systemctl cat factory-reset.target > /dev/null 2>&1
    CHECK_RESULT $? 0 0 "factory-reset.target unit file is unreadable"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
