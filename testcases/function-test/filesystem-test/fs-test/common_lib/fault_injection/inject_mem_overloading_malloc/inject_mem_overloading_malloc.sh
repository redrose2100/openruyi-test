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
#@Desc      	:   Inject to execute malloc which using mem more than 80% in 1 hour
#####################################
# shellcheck disable=SC1090

source "${OET_PATH}"/testcases/function-test/filesystem-test/fs-test/common_lib/fault_injection/fault_inject_lib/fault_inject_lib.sh

function create_oom() {
    ./mem_overloading_malloc
}

function inject() {
    [[ ! -f ./mem_overloading_malloc ]] && {
        make
    }

    CONCURRENCY_THREAD create_oom 360 &

    echoText "Success to set high cache miss." "green"
}

function clean() {
    for i in $(pgrep -f mem_overloading_malloc | grep -Ev "grep|bash" | awk '{print $2}'); do
        kill -9 "$i" &>/dev/null
    done

    make clean

    echoText "Success to clean injection." "green"
}

function query() {
    if pgrep -f mem_overloading_malloc | grep -Ev "grep|bash" &>/dev/null; then
        echoText "success: memory overloading malloc is running." "green"
    else
        echoText "Failed: memory overloading malloc is not running." "red"
    fi
}

function show() {
    echo "The purpose of this script is to execute malloc which using mem more than 80% in 1 hour"
    echo "For example:"
    echo "bash inject_mem_overloading_malloc inject"
    echo "bash inject_mem_overloading_malloc clean"
    echo "bash inject_mem_overloading_malloc query"
    echo "bash inject_mem_overloading_malloc show"
}

main "$@"
