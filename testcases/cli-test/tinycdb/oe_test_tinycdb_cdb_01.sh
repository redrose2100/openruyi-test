#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/02/20
# @License   :   Mulan PSL v2
# @Desc      :   Test tinycdb
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "tar tinycdb"
    tar -zxvf common/test.tar.gz
    mkdir tmp
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ! cdb -h 2>&1 | grep 'invalid option' && cdb -h 2>&1 | grep 'help:'
    CHECK_RESULT $? 0 0 "Failed option: cdb -h"
    cdb -c tmp/example test/example && test -f tmp/example 
    CHECK_RESULT $? 0 0 "Failed option: cdb -c"
    cdb -c -m tmp/example_m test/example_m && test -f tmp/example_m 
    CHECK_RESULT $? 0 0 "Failed option: -c -m"
    cdb -c -w tmp/example_dup test/example_dup 2>&1 | grep 'cdb: key .*one.* duplicated'
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -w "
    cdb -c -e tmp/example_e test/example_dup 2>&1 | grep 'cdb: key .*one.* duplicated'
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -e"
    cdb -c -r tmp/example_r test/example_dup && test -f tmp/example_r
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -r"
    cdb -c -0 tmp/example_0 test/example_dup && test -f tmp/example_0 
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -0"
    cdb -c -u tmp/example_u test/example_dup && test -f tmp/example_u 
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -u"
    cdb -q tmp/example one | grep 'Hello'
    CHECK_RESULT $? 0 0 "Failed option: cdb -q"
    cdb -q -n 1 tmp/example two | grep 'Goodbye'
    CHECK_RESULT $? 0 0 "Failed option: cdb -q -n"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp test/
    LOG_INFO "End to restore the test environment."
}

main "$@"
