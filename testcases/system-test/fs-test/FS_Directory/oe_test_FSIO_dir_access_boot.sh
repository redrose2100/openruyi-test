#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   @meitingli
#@Contact   	:   bubble_mt@outlook.com
#@Date      	:   2020-11-18
#@License   	:   Mulan PSL v2
#@Desc      	:   Take the test access of /boot
#####################################
# shellcheck disable=SC2010
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        ls -l /boot | grep "config" | grep "\-rwxr-xr-x"
    else
        ls -l /boot | grep "config" | grep "\-rw-r--r--"
    fi
    CHECK_RESULT $? 0 0 "The config on /boot has some errors."
    if [[ "${NODE1_FRAME}" != "riscv64" ]]; then
        ls -l /boot | grep "lost+found" | grep "drwx------"
    fi
    CHECK_RESULT $? 0 0 "The lost+found on /boot has some errors."
    if [[ "${NODE1_FRAME}" == "riscv64" ]]; then
        ls -l /boot | grep "initramfs" | grep "\-rwxr-xr-x"
    else
        ls -l /boot | grep "initramfs" | grep "\-rw-------"
    fi
    CHECK_RESULT $? 0 0 "The initramfs on /boot has some errors."
    LOG_INFO "End to run test."
}

main "$@"
