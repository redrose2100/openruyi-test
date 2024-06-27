#!/usr/bin/bash-completion

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
#@Desc      	:   Run bash-completion testsuite
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

# 测试点的执行
function run_test() {
    LOG_INFO "Start to run test."

    declare -A allTests
    getCasesFromFile allTests testcases.txt

    pushd ./tmp_test/completions/ || exit
    export LANG=en_US.UTF-8
    for file in "${!allTests[@]}"; do
        if [ -e ./"$file" ]; then
            bash -O extglob -n ./"$file"
            CHECK_RESULT $? 0 0 "run bash-completion test ${file} fail"
        fi
    done
    popd || exit

    LOG_INFO "End to run test."
}

main "$@"
