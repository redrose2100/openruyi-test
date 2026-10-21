#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   Li, Meiting
#@Contact   	:   244349477@qq.com
#@Date      	:   2021-04-09
#@License   	:   Mulan PSL v2
#@Desc      	:   Inject to execute kmalloc which using mem more than 80% in 1 hour
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/testcases/function-test/filesystem-test/fs-test/common_lib/fault_injection/fault_inject_lib/fault_inject_lib.sh

function inject() {
    [[ ! -f ./mem_overloading_kmalloc.ko ]] && {
        make
    }

    MemTotal=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    ko_size=$((MemTotal * 4 / 10240))
    if insmod mem_overloading_kmalloc.ko size="$ko_size"; then
        echoText "Failed to set high mem using by kmalloc." "red"
        sleep 2
        return 1
    fi
    sleep 20
    echoText "Success to set high mem using by kmalloc." "green"
}

function clean() {
    rmmod mem_overloading_kmalloc
    make clean
    echoText "Success to clean injection." "green"
}

function query() {
    if pgrep -f mem_overloading_kmalloc | grep -Ev "grep|bash" &>/dev/null; then
        echoText "success: memory overloading malloc is running." "green"
    else
        echoText "Failed: memory overloading malloc is not running." "red"
    fi
}

function show() {
    echo "The purpose of this script is to execute kmalloc which using mem more than 80% in 1 hour"
    echo "For example:"
    echo "bash inject_mem_overloading_kmalloc inject"
    echo "bash inject_mem_overloading_kmalloc clean"
    echo "bash inject_mem_overloading_kmalloc query"
    echo "bash inject_mem_overloading_kmalloc show"
}

main "$@"
