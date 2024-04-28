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
#@Desc      	:   Run findutils testsuite
#####################################
# shellcheck disable=SC1091,SC2185
source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    version=$(find --version | grep "GNU findutils" | awk '{print $4}')
    export built_programs='find oldfind xargs frcode locate updatedb ' VERSION=$version
    PATH="$(pwd)/tmp_test/find:$(pwd)/tmp_test/locate:$(pwd)/tmp_test/xargs:""$PATH"
    sed -i "s/\${srcdir}\/..\/doc/./g" ./tmp_test/check-regexprops
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."

    declare -A ignoreFail
    getCasesFromFile ignoreFail ignore.txt

    pushd ./tmp_test/ || exit
    REGEXPROPS=regexprops ./check-regexprops
    CHECK_RESULT $? 0 0 "run findutils testcase check-regexprops fail"
    ./test_splitstring
    CHECK_RESULT $? 0 0 "run findutils testcase test_splitstring fail"

    while read -r line; do
        [[ ${ignoreFail[$line]} -eq 1 ]] && continue
        testone="${line%.sh}"
        if [[ "${line}" != tests/* ]]; then
            cd ./gnulib-tests/ || exit
            outStr=$(EXEEXT='' srcdir='.' LOCALE_FR='none' LOCALE_FR_UTF8='none' LOCALE_FR='none' LOCALE_TR_UTF8='none' LOCALE_JA='none' LOCALE_ZH_CN='zh_CN.GB18030' LOCALE_ZH_CN='zh_CN.GB18030' /bin/sh ./../test-driver --test-name "${testone}".test --log-file "${testone}".log --trs-file "${testone}".trs -- "./$line")
            cd ../
        else
            outStr=$(/bin/sh ./test-driver --test-name "${testone}".test --log-file "${testone}".log --trs-file "${testone}".trs -- "./$line")
        fi
        echo "Output: $outStr"
        outResult=${outStr%%:*}
        if [[ "${outResult}" != "PASS" && "${outResult}" != "SKIP" && "${outResult}" != "XFAIL" ]]; then
            CHECK_RESULT 1 0 0 "run findutils testcase $line fail"
            cat "${line}".log
            ((failed++))
        elif [[ "${outResult}" == "SKIP" || ${ignoreFail[$line]} -eq 1 ]]; then
            ((skipped++))
        else
            ((passed++))
        fi
    done <../file.txt
    popd || exit
    total=$((failed + skipped + passed))

    LOG_INFO "Total cases: $total"
    LOG_INFO "Passed cases: $passed"
    LOG_INFO "skipped cases: $skipped"
    LOG_INFO "Failed cases: $failed"

    LOG_INFO "End to run findutils test."
}

main "$@"
