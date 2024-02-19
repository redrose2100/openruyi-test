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
#@Author    	:   hukun
#@Contact   	:   hu_kun@hoperun.com
#@Date      	:   2023-12-26
#@License   	:   Mulan PSL v2
#@Desc      	:   Test gdb
#####################################
# shellcheck disable=SC1091
source ../comm_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    pushd ./tmp_test/testsuite || exit 1
    sed -i "s#set srcdir .*#set srcdir $(pwd)#" site.exp
    ${RUNTEST} GDB=/usr/bin/gdb --status &> gdb_test.log
    unexpect_failures=58
    failed_num=$(grep "# of unexpected failures" gdb_test.log | awk '{print $NF}')
    CHECK_RESULT "${failed_num}" "${unexpect_failures}" 0 "unexpected failures ${failed_num}!"
    popd || exit
    LOG_INFO "End to run test."
}

# 后置处理，恢复测试环境
function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./tmp_test
    LOG_INFO "End to restore the test environment."
}

main "$@"
