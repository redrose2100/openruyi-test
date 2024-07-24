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
# @Desc      :   Compiler csmith
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
    DNF_INSTALL "gcc gcc-* make cmake m4 clang git"
    git clone https://code.osssc.ac.cn/oepkgs/os-test-framework/csmith.git
    sleep 3
    mkdir -p /usr/local/csmith
    cd csmith || exit 255
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local/csmith .
    make & make install
    export PATH=$PATH:/usr/local/csmith/bin
    failed_logs_dir=/tmp/oe_test_csmith/failed_cases/
    if [ -d "/tmp/os_test_csmith/failed_cases" ]; then
        rm -rf "$failed_logs_dir"
    fi
    mkdir -p "$failed_logs_dir"

    LOG_INFO "End to prepare the test environment."
}



function run_test() {
    LOG_INFO "Start to run test."
    for i in  $(seq 1 1000000)
    do
        cfile="random$i.c"
        csmith > "$cfile"
        gcc "$cfile" -I/usr/local/csmith/include -o random_gcc
        clang "$cfile" -I/usr/local/csmith/include -o random_clang
        gcc_checksum=$(./random_gcc)
        clang_checksum=$(./random_clang)
        gcc_value=${gcc_checksum:11}
        clang_value=${clang_checksum:11}
        if [ "$gcc_value" = "$clang_value" ]; then
           echo "${GREEN}Passed${NONE}"
           ((passed += 1))
        else
           echo "${RED}Failed${NONE}"
           cp "$cfile" "$failed_logs_dir"
           ((failed += 1))
	      fi
        ((total += 1))
        rm -rf "$cfile"
        rm -rf random_gcc
        rm -rf random_clang
    done
    CHECK_RESULT "$total" "$passed" 0 "Failed to run the test csmith_run.sh"
    ls "$failed_logs_dir"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf csmith
    rm -rf /usr/local/csmith
    rm -rf /tmp/oe_test_csmith/failed_cases/
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"