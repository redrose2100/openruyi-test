#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      	:   2024-01-15 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run libtiff testsuite
#####################################
# shellcheck disable=SC1091,SC2155
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt
    total=0
    passed=0
    failed=0
    skipped=0
    pushd ./tmp_test/test/ || exit
    export srcdir=$(pwd)
    sed -i 's/relink_command=/#relink_command=/g' ../tools/*
    while read -r line; do
        ((total++))
        outStr=$(../test-driver --test-name "$line" --log-file "$line".log --trs-file "$line".trs -- ./"$line")
        echo "Output: $outStr"
        outResult=${outStr%%:*}
        if [[ "${outResult}" != "PASS" && "${outResult}" != "SKIP" && "${outResult}" != "XFAIL" && ${ignoreFail[$line]} -ne 1 ]]; then
            CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
            cat "${line}".log
            ((failed++))
        elif [[ "${outResult}" == "SKIP" || ${ignoreFail[$line]} -eq 1 ]]; then
            ((skipped++))
        else
            ((passed++))
        fi
    done <../testfile
    popd || exit

    LOG_INFO "Total cases: $total"
    LOG_INFO "Passed cases: $passed"
    LOG_INFO "skipped cases: $skipped"
    LOG_INFO "Failed cases: $failed"
    LOG_INFO "End to run test."
}

main "$@"
