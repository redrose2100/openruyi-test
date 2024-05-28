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

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/tests/ || exit
    
    sed -i "s/echo \$x ; sh \$x ; rm/sh \$x ; echo \$? \$x ;rm/g" run-all
    BUILD_DIR=$(pwd)/../ PATH=$(pwd):$PATH THIS_SH=/bin/bash /bin/sh run-all declare -r SHELLOPTS="braceexpand:hashall:interactive-comments" >tmp_bash_log 2>&1
    grep "[0-9] run-" tmp_bash_log >resultfile
    while IFS= read -r line; do
        testresult=${line%%' '*}
        testName="${line##*' '}"
        [[ ${ignoreFail[$testName]} -eq 1 ]] && continue
        if [ "${testresult}" -eq 1 ]; then
            CHECK_RESULT 1 0 0 "run bash testcase $testName fail"
            testname2=$(grep -B 1 "$testName$" resultfile | sed "/$testName/d" | awk '{print $2}')
            sed -n "/$testname2$/,/$testName$/p" tmp_bash_log
        fi
    done <"resultfile"
    popd || exit

    LOG_INFO "End to run test."
}

main "$@"
