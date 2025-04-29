#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2024-03-19
# @License   :   Mulan PSL v2
# @Desc      :   Test CPU model
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    DNF_INSTALL "dmidecode lshw pciutils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    if [[ "${NODE1_MACHINE}" =~ "kvm" ]]; then
        LOG_INFO "The current environment is not a physical machine."
    else
        if [ "$NODE1_FRAME"x == "aarch64"x ]; then
            lscpu | grep -i model | grep -i kunpeng
            CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
            lspci | grep -i huawei
            CHECK_RESULT $? 0 0 "The lspci command displays an incorrect CPU model"
            dmidecode -t processor | grep -i version | grep -i kunpeng
            CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
            lshw -class processor | grep -i kunpeng
            CHECK_RESULT $? 0 0 "The lshw command displays an incorrect CPU model"
        elif [ "$NODE1_FRAME"x == "riscv64"x ]; then
            lscpu | grep -i Architecture | grep -i riscv64
            CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
            dmidecode -t processor | grep -i Family | grep -i rv64
            CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
            grep -i isa /proc/cpuinfo | grep -i rv64
            CHECK_RESULT $? 0 0 "The /proc/cpuinfo displays an incorrect CPU model"
        else
            lscpu | grep -i model | grep -ciE 'intel|amd' | grep 2
            CHECK_RESULT $? 0 0 "The lscpu command displays an incorrect CPU model"
            lspci | grep -iE 'intel|amd'
            CHECK_RESULT $? 0 0 "The lspci command displays an incorrect CPU model"
            dmidecode -t processor | grep -i version | grep -iE 'intel|amd'
            CHECK_RESULT $? 0 0 "The dmidecode command displays an incorrect CPU model"
            grep -i model /proc/cpuinfo | grep -iE 'intel|amd'
            CHECK_RESULT $? 0 0 "The /proc/cpuinfo displays an incorrect CPU model"
            lshw -class processor | grep -iE 'intel|amd'
            CHECK_RESULT $? 0 0 "The lshw command displays an incorrect CPU model"
        fi
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    export LANG=${OLD_LANG}
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
