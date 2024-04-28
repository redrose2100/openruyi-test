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
#@Date      	:   2024-01-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run bash testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."
    # 用例总数
    total=0
    # 用例成功数
    passed=0
    # 用例失败数
    failed=0
    # 用例失败数
    skipped=0

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/tests/ || exit

    sed -i "s/echo \$x ; sh \$x ; rm/sh \$x ; echo \$? \$x ;rm/g" run-all
    BUILD_DIR=$(pwd)/../ PATH=$(pwd):$PATH THIS_SH=/bin/bash /bin/sh run-all declare -r SHELLOPTS="braceexpand:hashall:interactive-comments" >tmp_bash_log 2>&1
    grep "[0-9] run-" tmp_bash_log >resultfile
    while IFS= read -r line; do
        ((total++))
        testresult=${line%%' '*}
        testName="${line##*' '}"
        [[ ${ignoreFail[$testName]} -eq 1 ]] && ((++skipped)) && continue
        if [ "${testresult}" -eq 1 ]; then
            ((failed++))
            CHECK_RESULT 1 0 0 "run bash testcase $testName fail"
            testname2=$(grep -B 1 "$testName$" resultfile | sed "/$testName/d" | awk '{print $2}')
            sed -n "/$testname2$/,/$testName$/p" tmp_bash_log
        else
            ((passed++))
        fi
    done <"resultfile"
    popd || exit

    total=$((passed+skipped+failed))
    LOG_INFO "Total cases: $total"
    LOG_INFO "Passed cases: $passed"
    LOG_INFO "Failed cases: $failed"
    LOG_INFO "Skipped cases: $skipped"

    LOG_INFO "End to run test."
}

main "$@"
