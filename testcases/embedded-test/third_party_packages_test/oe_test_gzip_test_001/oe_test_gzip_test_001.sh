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
#@Date      	:   2023-11-24 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run gzip testsuite
#####################################
# shellcheck disable=SC1091,SC2010
source "${OET_PATH}/testcases/embedded-test/common_libs/comm_lib.sh"
source "${OET_PATH}/testcases/embedded-test/common_libs/common.sh"


# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt
    pushd ./tmp_test/tests/ || exit

    failTitles=("XPASS" "ERROR" "FAIL")
    for onetest in $(ls | grep -v -E "^M|\."); do

        [[ ${ignoreFail[$onetest]} -eq 1 ]] && continue
        testfile=$(find ./ -name "${onetest}")
        echo "Run: ../test-driver --test-name ${onetest} --log-file ${onetest}.log --trs-file ${onetest}.trs $testfile"
        outStr=$(../test-driver --test-name "${onetest}" --log-file "${onetest}".log --trs-file "${onetest}".trs "$testfile")
        echo "Output: $outStr"
        outTitle=${outStr%%:*}
        outTitle=$(echo "$outTitle" | sed -e 's/^[ \t]//g' -e 's/[ \t]*$//g')
        if [[ "${failTitles[*]}" =~ ${outTitle} && "${outTitle}" != "PASS" ]]; then
            CHECK_RESULT 1 0 0 "run gzip testcase $onetest fail"
            cat "${onetest}".log
        fi
    done

    popd || exit

    LOG_INFO "End to run test."
}

main "$@"
