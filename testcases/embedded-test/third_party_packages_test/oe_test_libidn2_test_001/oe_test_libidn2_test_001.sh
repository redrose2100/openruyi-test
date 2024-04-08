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
#@Desc      	:   Run libidn2 testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    pushd ./tmp_test/tests/ || exit
    testlist=(test-punycode test-lookup test-register test-strerror test-tounicode test-locale test-glibc)
    for onetest in "${testlist[@]}"; do
        outStr=$(../test-driver --test-name "${onetest}".test --log-file "${onetest}".log --trs-file "${onetest}".trs -- ./"$onetest")
        echo "Output: $outStr"
        outResult=${outStr%%:*}
        if [[ "${outResult}" != "PASS" && "${outResult}" != "SKIP" && "${outResult}" != "XFAIL" ]]; then
            CHECK_RESULT 1 0 0 "run libidn2 testcase $onetest fail"
            cat "${onetest}".log
        fi
    done
    popd || return

    LOG_INFO "End to run test."
}

main "$@"
