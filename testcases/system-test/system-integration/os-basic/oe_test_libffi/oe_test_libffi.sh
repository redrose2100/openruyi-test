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
#@Author        :   wangxiaorou
#@Contact       :   wangxiaorou@uniontech.com
#@Date          :   2023-02-20
#@License       :   Mulan PSL v2
#@Desc          :   the function of libffi
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "libffi libffi-devel gcc"
    ls ./a.out && rm -rf ./a.out
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    gcc -w ./libffi_test.c -lffi
    CHECK_RESULT $? 0 0 "compilation of libffi_test.c is failed"
    ls ./a.out
    CHECK_RESULT $? 0 0 "file a.out is not created"
    ./a.out
    CHECK_RESULT $? 0 0 "The executable program a.out execution has failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ls ./a.out && rm -rf ./a.out
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
