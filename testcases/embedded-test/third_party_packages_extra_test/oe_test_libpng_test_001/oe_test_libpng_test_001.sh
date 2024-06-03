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
#@Desc      	:   Run libpng testsuite
#####################################
# shellcheck disable=SC1091,SC2155
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    total=0
    passed=0
    failed=0
    skipped=0
    pushd ./tmp_test/ || exit
    export srcdir=$(pwd)
    sed -i 's/relink_command=/#relink_command=/g' png*
    while read -r line; do
        ((total++))
        testname=${line##*/}
        outStr=$(./test-driver --test-name "$testname" --log-file "$testname".log --trs-file "$testname".trs -- ./tests/"$testname")
        echo "Output: $outStr"
        outResult=${outStr%%:*}
        if [[ "${outResult}" != "PASS" && "${outResult}" != "SKIP" && "${outResult}" != "XFAIL" ]]; then
            CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
            cat "${testname}".log
            ((failed++))
        elif [[ "${outResult}" == "SKIP" ]]; then
            ((skipped++))
        else
            ((passed++))
        fi
    done <./testfile
    popd || exit

    LOG_INFO "Total cases: $total"
    LOG_INFO "Passed cases: $passed"
    LOG_INFO "Failed cases: $skipped"
    LOG_INFO "Failed cases: $failed"
    LOG_INFO "End to run test."
}

main "$@"
