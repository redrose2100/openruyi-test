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

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "efivar efibootmgr"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    efibootmgr
    ret=$?
    if [ $ret -ne 0 ] ;then
        LOG_WARN "System is not in UEFI mode. Exiting test."
        LOG_INFO "End to run test."
        return 0
    fi
    efivar -l |grep -i "boot"
    CHECK_RESULT $? 0 0 "Failed to read uefi variable"
    uefi_value=$(efivar -l |grep -i "boot" |head -1)
    efivar -n "${uefi_value}"
    CHECK_RESULT $? 0 0 "Failed to read uefi variable"
    efivar -n "${uefi_value}" -d 99
    CHECK_RESULT $? 0 0 "Execution failed"
    efivar -n "${uefi_value}" -e test.txt
    test -f test.txt
    CHECK_RESULT $? 0 0 "File generation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf test.txt
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
