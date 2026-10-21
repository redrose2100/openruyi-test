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
    cdb -c tmp/example test/example && cdb -l tmp/example | grep '+3:one'
    CHECK_RESULT $? 0 0 "Failed option: cdb -l"
    cdb -d tmp/example 2>&1 | grep '+3,7:two->Goodbye'
    CHECK_RESULT $? 0 0 "Failed option: cdb -d"
    cdb -s tmp/example 2>&1 | grep 'number of records: 2'
    CHECK_RESULT $? 0 0 "Failed option: cdb -s"
    cdb -c -p 0644 tmp/example test/example && ls -ll tmp/example | grep '\-rw\-r\-\-r\-\-'
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -p "
    cdb -c -wrue0 tmp/example_e test/example_dup 2>&1 | grep 'duplicated'
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -wrue0 "
    cdb -c -t a.tmp tmp/example_e test/example_dup 
    CHECK_RESULT $? 0 0 "Failed option: cdb -c -t "
    cdb -l -m tmp/example | grep 'one'
    CHECK_RESULT $? 0 0 "Failed option: cdb -l -m"
    cdb -d -m tmp/example | grep 'two Goodbye'
    CHECK_RESULT $? 0 0 "Failed option: cdb -d -m"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp test/
    LOG_INFO "End to restore the test environment."
}

main "$@"
