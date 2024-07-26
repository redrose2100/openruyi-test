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
#@Date      	:   2024-01-19 14:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Run tar testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run tar test."

    EXECUTE_T="1440m"
    echo "EXECUTE_T = ${EXECUTE_T}"

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/tests/ || exit
    /bin/sh ./testsuite
    sed -n '/Failed tests:/,/Skipped tests:/p' testsuite.log | grep -E '[0-9]+:' | awk '{print $1,$2}' >tmp.log    
    while read -r line; do
        [[ ${ignoreFail[$line]} -eq 1 ]]
        CHECK_RESULT $? 0 0 "run tar testcase $line fail"
    done <./tmp.log
    sed -n '/Failed tests:/,/Skipped tests:/p' testsuite.log
    popd || return

    LOG_INFO "End to run tar test."
}

main "$@"
