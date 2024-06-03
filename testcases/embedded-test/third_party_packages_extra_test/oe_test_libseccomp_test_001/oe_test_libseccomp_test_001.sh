#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   wangshan
#@Contact   	:   wang_shan001@hoperun.com
#@Date      	:   2024-01-10 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libseccomp testsuite
#####################################
# shellcheck disable=SC1091,SC2034
source ../comm_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    EXECUTE_T="120m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    sed -i 's/..\/include\/seccomp-syscalls.h/.\/seccomp-syscalls.h/g' ./tmp_test/arch-syscall-check
    sed -i 's/\/usr\/bin\/sed/\/bin\/sed/g' ./tmp_test/tools/*
    sed -i 's/cd \/root.*tools/cd ..\/tools/g' ./tmp_test/tools/*

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/ || exit
    ./arch-syscall-check
    CHECK_RESULT $? 0 0 "run libseccomp test arch-syscall-check fail"
    popd || exit

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/tests/ || exit
    ./regression >tmp_log.log 2>&1

    while read -r line; do
        [[ $line =~ .*"test mode:".* ]] && continue
        [[ $line =~ .*"test type:".* ]] && continue
        [[ $line =~ .*"batch name":.* ]] && continue
        if [[ $line =~ "result:" ]]; then
            resultTitle=${line%%:*}
            resultTail=${line##*:}
            testcase=$(echo "$resultTitle" | sed -e 's/Test //g' -e 's/%%.*//g')
            [[ ${ignoreFail[$testcase]} -eq 1 ]] && continue
            if ! [[ "${resultTail}" =~ "SUCCESS" || "${resultTail}" =~ "SKIPPED" ]]; then
                CHECK_RESULT 1 0 0 "run libseccomp $resultTitle fail"
            fi
        fi
    done <tmp_log.log
    popd || exit

    LOG_INFO "End to run test."
}

main "$@"
