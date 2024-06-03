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
#@Desc      	:   Run audit testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    sed -i 's/relink_command=/#relink_command=/g' ./auparse_tests/lookup_test ./lib_tests/lookup_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    pushd ./tmp_test/ || exit
    test_list=('lib_tests/lookup_test' 'lib_tests/test/lookup_test' 'auparse_tests/lookup_test' 'ilist_test' 'slist_test' 'test-queue')
    for onetest in "${test_list[@]}"; do
        if [ -e "${onetest}" ]; then
            outStr=$(/bin/sh ./test-driver --test-name "${onetest}".test --log-file "${onetest}".log --trs-file "${onetest}".trs -- "./$onetest")
            echo "Output: $outStr"
            outResult=${outStr%%:*}
            if [[ "${outResult}" != "PASS" && "${outResult}" != "SKIP" && "${outResult}" != "XFAIL" ]]; then
                CHECK_RESULT 1 0 0 "run audit testcase $onetest fail"
                cat "${onetest}".log
            fi
        fi
    done
    popd || exit

    LOG_INFO "End to run audit test."
}

main "$@"
