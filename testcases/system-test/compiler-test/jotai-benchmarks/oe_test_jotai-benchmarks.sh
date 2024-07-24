#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   honghua
# @Contact   :   honghua@iscas.ac.cn
# @Date      :   2024/07/23
# @License   :   Mulan PSL v2
# @Desc      :   Compiler jotai-benchmarks
# ############################################
# shellcheck disable=SC2034,SC2154,SC1091


source "${OET_PATH}"/libs/locallibs/common_lib.sh

function config_params(){
    L0G_INFO "Start to config params of the case."
    EXECUTE_T="600m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc gcc-* git"
    git clone https://gitee.com/redrsoe2100/jotai-benchmarks.git
    cd jotai-benchmarks || exit 255
    if [ -d "./anghaLeaves_failure_log" ]; then
        rm -rf anghaLeaves_failure_log
    fi
	  if [ -d "./anghaMath_failure_log" ]; then
        rm -rf anghaMath_failure_log
    fi
    failed=0
    passed=0
    total=0
    mkdir anghaLeaves_failure_log
	  mkdir anghaMath_failure_log
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    anghaleaves_array=()
    while IFS= read -r -d $'\0' file; do
        anghaleaves_array+=("$file")
    done < <(find benchmarks/anghaLeaves -type f -print0)
    anghamath_array=()
    while IFS= read -r -d $'\0' file; do
        anghamath_array+=("$file")
    done < <(find benchmarks/anghaMath -type f -print0)

    for src in "${anghaleaves_array[@]}"
    do
        failed_log=./anghaLeaves_failure_log/$(basename "$src").log
        gcc "$src" -o "$src".out &> "$failed_log"
        if [ ! -e "$src".out ]; then
            echo "${RED}Compilation Error${NONE} $src"
            ((failed += 1))
        else
            "$src".out &>> "$failed_log"
            if "$src".out 0 &>> ."$failed_log"; then
                echo "${GREEN}Passed${NONE} $src"
                rm -rf "$src".out
                rm -rf "$failed_log"
                ((passed += 1))
            else
                echo "${RED}Test Run Failed${NONE} $src"
                ((failed += 1))
            fi
        fi
        ((total += 1))
    done
    for src in "${anghamath_array[@]}"
    do
        failed_log=./anghaMath_failure_log/$(basename "$src").log
        gcc "$src" -o "$src".out &> "$failed_log"
        if [ ! -e "$src".out ]; then
            echo "${RED}Compilation Error${NONE} $src"
            ((failed += 1))
        else
            "$src".out &>> "$failed_log"
            if "$src".out 0 &>> "$failed_log"; then
                echo "${GREEN}Passed${NONE} $src"
                rm -rf "$src".out
                rm -rf "$failed_log"
                ((passed += 1))
            else
                echo "${RED}Test Run Failed${NONE} $src"
                ((failed += 1))
            fi
        fi
        ((total += 1))
    done
    CHECK_RESULT "$total" "$passed" 0 "failed to run jotai-benchmarks cases"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf jotai-benchmarks
    rm -rf anghaLeaves_failure_log
    rm -rf anghaMath_failure_log
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"