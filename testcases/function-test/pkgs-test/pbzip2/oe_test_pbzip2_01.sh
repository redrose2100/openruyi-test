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
    mkdir -p tmp
    echo 'hello' >> tmp/a.txt
    echo 'hello' >> tmp/b.txt
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pbzip2 -h 2>&1 | grep 'Usage: pbzip2'
    CHECK_RESULT $? 0 0 "Failed option: -h"
    pbzip2 -V 2>&1 /dev/null | grep 'Parallel BZIP2'
    CHECK_RESULT $? 0 0 "Failed option: -V"
    pbzip2 tmp/a.txt && pbzip2 tmp/b.txt
    pbzip2 -d tmp/a.txt.bz2 && test -f tmp/a.txt
    CHECK_RESULT $? 0 0 "Failed option: -d"
    pbzip2 --decompress tmp/b.txt.bz2 && test -f tmp/b.txt
    CHECK_RESULT $? 0 0 "Failed option: --decompress"
    pbzip2 --stdout tmp/b.txt | grep -a 'BZh'
    CHECK_RESULT $? 0 0 "Failed option: --stdout" 
    pbzip2 -c tmp/a.txt | grep -a 'BZh'
    CHECK_RESULT $? 0 0 "Failed option: -c" 
    pbzip2 -k tmp/b.txt && test -f tmp/b.txt
    CHECK_RESULT $? 0 0 "Failed option: -k"
    pbzip2 --keep tmp/a.txt && test -f tmp/a.txt
    CHECK_RESULT $? 0 0 "Failed option: --keep"
    pbzip2 -f tmp/b.txt && test -f tmp/b.txt.bz2
    CHECK_RESULT $? 0 0 "Failed option: -f"
    pbzip2 --force tmp/a.txt && test -f tmp/a.txt.bz2
    CHECK_RESULT $? 0 0 "Failed option: --force"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp
    LOG_INFO "End to restore the test environment."
}

main "$@"
