#!/usr/bin/bash

# Copyright (c) 2022. huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/18
# @License   :   Mulan PSL v2
# @Desc      :   Test ppbzip2
# #############################################

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pbzip2"
    mkdir -p tmp1/
    echo 'hello' >> tmp1/b.txt
    echo 'hello' >> tmp1/a.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pbzip2 --help 2>&1 | grep 'Usage: pbzip2'
    CHECK_RESULT $? 0 0 "Failed option: --help"
    pbzip2 --version 2>&1 /dev/null | grep 'Parallel BZIP2'
    CHECK_RESULT $? 0 0 "Failed option: --version"
    pbzip2 -k -z tmp1/b.txt && test -f tmp1/b.txt.bz2
    CHECK_RESULT $? 0 0 "Faileerbosd option: -z"
    pbzip2 -k --compress tmp1/a.txt && test -f tmp1/a.txt.bz2
    CHECK_RESULT $? 0 0 "Faileerbosd option: --compress"
    rm -rf tmp1/b.txt.bz2 && pbzip2 -k -v tmp1/b.txt 2>&1 | grep 'tmp1/b.txt'
    CHECK_RESULT $? 0 0 "Faileerbosd option: -v"
    rm -rf tmp1/a.txt.bz2 && pbzip2 -k --verbose tmp1/a.txt 2>&1 | grep 'tmp1/a.txt'
    CHECK_RESULT $? 0 0 "Faileerbosd option: --verbose"
    rm -rf tmp1/b.txt.bz2 && pbzip2 -k -q tmp1/b.txt
    CHECK_RESULT $? 0 0 "Failed option: -q"  
    rm -rf tmp1/a.txt.bz2 && pbzip2 -k --quiet tmp1/a.txt
    CHECK_RESULT $? 0 0 "Failed option: --quiet"  
    rm -rf tmp1/a.txt.bz2 && pbzip2 -v -l tmp1/a.txt 2>&1 | grep 'Load Average'
    CHECK_RESULT $? 0 0 "Failed option: -l"
    rm -rf tmp1/b.txt.bz2 && pbzip2 -v --loadavg  tmp1/b.txt 2>&1 | grep 'Load Average'
    CHECK_RESULT $? 0 0 "Failed option: --loadavg " 
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp1
    LOG_INFO "End to restore the test environment."
}

main "$@"
