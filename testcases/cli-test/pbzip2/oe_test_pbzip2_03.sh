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
# @Desc      :   Test pbzip2
# #############################################
# shellcheck disable=SC1091

source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "pbzip2"
    yumdownloader pbzip2
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    pbzip2 -v -k -b1  pbzip2*.rpm 2>&1 | grep 'File Block Size: 100 KB'
    CHECK_RESULT $? 0 0 "Failed option: -b" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 -1 -k -v pbzip2*.rpm 2>&1 | grep 'BWT Block Size: 100 KB'
    CHECK_RESULT $? 0 0 "Failed option: -1" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 -m100 -k -v pbzip2*.rpm 2>&1 | grep 'Maximum Memory: 100 MB'
    CHECK_RESULT $? 0 0 "Failed option: -m" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 -p10 -v -k pbzip2*.rpm 2>&1 | grep 'CPUs: 10'
    CHECK_RESULT $? 0 0 "Failed option: -p" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 -r -k -v pbzip2*.rpm 2>&1 | grep 'Output Size: .* bytes'
    CHECK_RESULT $? 0 0 "Failed option: -r" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 --read -k -v pbzip2*.rpm 2>&1 | grep 'Output Size: .* bytes'
    CHECK_RESULT $? 0 0 "Failed option: --read" 
    rm -rf pbzip2*.rpm.bz2 && pbzip2 -S1 -k -v pbzip2*.rpm 2>&1 | grep 'Stack Size: .* KB'
    CHECK_RESULT $? 0 0 "Failed option: -S"
    pbzip2 -t -v pbzip2*.rpm.bz2 2>&1 | grep ' Test: OK'
    CHECK_RESULT $? 0 0 "Failed option: -t"
    pbzip2 --test -v pbzip2*.rpm.bz2 2>&1 | grep ' Test: OK'
    CHECK_RESULT $? 0 0 "Failed option: --test"
    pbzip2 --test --ignore-trailing-garbage=1 -v pbzip2*.rpm.bz2 2>&1 | grep ' Test: OK'
    CHECK_RESULT $? 0 0 "Failed option: --ignore-trailing-garbage"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf pbzip2*.rpm pbzip2*.rpm.bz2
    LOG_INFO "End to restore the test environment."
}

main "$@"
