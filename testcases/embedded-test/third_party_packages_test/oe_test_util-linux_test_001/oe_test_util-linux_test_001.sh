#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   saarloos
#@Contact       :   9090-90-90-9090@163.com
#@Date          :   2020-08-12 11:03:43
#@License       :   Mulan PSL v2
#@Desc          :   Run util-linux testsuite
#####################################

source ../comm_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."

    pushd ./tmp_test/run_test_dir/

    for wrapper in sample-partitions test_uuid_parser; do
        if [ -f "$wrapper" ] && grep -q "program=lt-" "$wrapper" 2>/dev/null; then
            bin_name=$(grep "program=lt-" "$wrapper" | sed "s/.*program=lt-'\(.*\)'.*/\1/")
            if [ -f ".libs/$bin_name" ] && [ ! -f ".libs/lt-$bin_name" ]; then
                cp ".libs/$bin_name" ".libs/lt-$bin_name"
            fi
        fi
    done

    popd

    LOG_INFO "End to prepare the test environment."
}

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    export PATH="/bin:/sbin:${PATH}"

    pushd ./tmp_test/run_test_dir/

    chmod 777 ./*

    ignoreFail=(" FAILED (script/options-size)")
    exculdeTest="libsmartcols/fromfile libsmartcols/title"
    sh ./tests/run.sh --show-diff --exclude="${exculdeTest}" > tmp_log.log 2>&1
    cat tmp_log.log
    while read line; do
        [[ "$line" =~ ^[[:space:]]*:[[:space:]] ]] && continue
        if [[ $line =~ "..." && $line =~ ":" ]]; then
            resuleTitle="${line#*...}"
            runtestName="${line%...*}"
            local should_ignore=0
            for ignore_item in "${ignoreFail[@]}"; do
                [[ "${resuleTitle}" =~ "${ignore_item}" ]] && { should_ignore=1; break; }
            done
            if [[ $should_ignore -eq 1 ]]; then
                continue
            else
                echo "${resuleTitle}" | grep -q "FAILED" && echo "${resuleTitle}" | grep -qv "KNOWN"
                CHECK_RESULT $? 0 1 "run util-linux ${runtestName} testcase fail."
            fi
        fi

    done < tmp_log.log

    popd

    LOG_INFO "End to run test."
}

main "$@"
