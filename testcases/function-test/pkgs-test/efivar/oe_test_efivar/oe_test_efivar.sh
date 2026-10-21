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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2024/02/23
# @License   :   Mulan PSL v2
# @Desc      :   Basic functional verification of efivar
# #############################################
# shellcheck disable=SC2120

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "efivar efibootmgr"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    # 判断是否为 UEFI 环境
    efibootmgr
    ret=$?
    if [ $ret -ne 0 ]; then
        LOG_WARN "System is not in UEFI mode. Exiting test."
        LOG_INFO "End to run test."
        return 0
    fi

    # 获取 boot 变量
    boot_list=$(efivar -l | grep -i "boot")
    CHECK_RESULT $? 0 0 "Failed to read UEFI variable list"

    uefi_value=$(echo "$boot_list" | head -1)

    # 读取变量并校验输出
    efivar -n "${uefi_value}" > out.txt
    CHECK_RESULT $? 0 0 "Failed to read UEFI variable"
    [ -s out.txt ]
    CHECK_RESULT $? 0 0 "UEFI variable content is empty"

    # print-decimal仅表示以十进制格式显示数据
    output=$(efivar -n "${uefi_value}" -d 2>/dev/null)
    CHECK_RESULT $? 0 0 "UEFI variable -d failed"
    
    # 验证输出非空
    [ -n "$output" ]
    CHECK_RESULT $? 0 0 "efivar -d output is empty"

    # 验证输出为合法十进制格式（每个token为0-255的纯数字）
    echo "$output" | tr ' \t\n' '\n'  | sed '/^$/d'  | grep -qvE '^[0-9]{1,3}$'
    CHECK_RESULT $? 1 0 "efivar -d output is NOT valid decimal format"

    # 导出文件并校验
    efivar -n "${uefi_value}" -e test.txt
    test -f test.txt
    CHECK_RESULT $? 0 0 "File generation failed"
    [ -s test.txt ]
    CHECK_RESULT $? 0 0 "Exported file is empty"

    # 负例：非法变量
    efivar -n "Invalid-Variable-Name"
    CHECK_RESULT $? 0 1 "Reading invalid variable should fail"

    # 权限测试（不影响 CI）
    if [ "$(id -u)" -ne 0 ]; then
        if efivar -l > /dev/null 2>&1; then            
            LOG_WARN "Non-root user can access efivar, skip permission check."
        else
            LOG_INFO "Permission restriction works as expected."
        fi
    else
        LOG_INFO "Running as root, skip permission negative test."
    fi

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.txt out.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
