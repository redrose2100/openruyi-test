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
#@Date      	:   2024-01-11 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run sed testsuite
#####################################
# shellcheck disable=SC1091,SC2155
source "${OET_PATH}"/testcases/embedded-test/common_libs/comm_lib.sh
source "${OET_PATH}/testcases/embedded-test/common_libs/common.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    export abs_top_srcdir=$(pwd)/tmp_test
    export built_programs=sed
    export VERSION=$(sed --version | grep "(GNU sed)" | awk '{print $4}')
    sed -i 's/\${1-..\/sed\/sed}/\/bin\/sed/g' ./tmp_test/testsuite/bsd.sh

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run sed test."

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/ || exit

    chmod +x ./testsuite/* ../file.txt
    failTitles=("XPASS" "ERROR" "FAIL" "SKIP")
    while read -r line; do
        onetest=$(echo "$line" | sed -r 's/\.sh//g')
        outStr=$(./test-driver --test-name "${onetest}" --log-file "${onetest}".log --trs-file "${onetest}".trs ./testsuite/"$line")
        echo "Output: $outStr"
        outResult=${outStr%%:*}
        [[ ${ignoreFail[$line]} -eq 1 ]] && continue
        if [[ "${failTitles[*]}" =~ ${outResult} && "${outResult}" != "PASS" && "${outResult}" != "SKIP" ]]; then
            CHECK_RESULT 1 0 0 "run sed testcase $onetest fail"
            cat "${onetest}".log
        fi
    done <../file.txt
    popd || return

    LOG_INFO "End to run sed test."
}

main "$@"
