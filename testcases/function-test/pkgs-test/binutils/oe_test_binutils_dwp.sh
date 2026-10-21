#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   Lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025-11-11
# @License   :   Mulan PSL v2
# @Desc      :   Test chcpu basic functionality
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    if [[ "${NODE1_FRAME}" != "x86_64" && "${NODE1_FRAME}" != "aarch64" ]]; then
        LOG_WARN "Current architecture (${NODE1_FRAME}) is not supported by powerapi, skipping test."
        exit 255
    fi
    DNF_INSTALL "binutils gcc"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start to run test."
    
    # create main.c
    echo "int main() { return 0; }" > main.c
    
    # compile with DRAFT enabled, generate main.dwo
    gcc -gsplit-dwarf -c main.c -o main.o

    # check if generated
    test -f main.dwo
    CHECK_RESULT $? 0 0 "unable to generate main.dwo" 1

    # try to merge draft into package
    dwp -o main.dwp main.o
    CHECK_RESULT $? 0 0 "dwp -o main.dwp main.o failed" 1

    test -f main.dwp
    CHECK_RESULT $? 0 0 "package failed doesn't generated"
    
    LOG_INFO "End of testcase execution!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf main.c main.o main.dwp main.dwo
    # shellcheck disable=SC2119
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
