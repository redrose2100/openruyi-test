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
#@Author    	:   wulei
#@Contact   	:   wulei@uniontech.com
#@Date      	:   2023-04-04
#@License   	:   Mulan PSL v2
#@Desc      	:   Basic function check of openblas package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "gcc openblas"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test -e sampleblas.c
    CHECK_RESULT $? 0 0 'sampleblas.c file not found'
    gcc -o sampleblas sampleblas.c -lopenblas
    CHECK_RESULT $? 0 0 'Compilation failed'
    test -e sampleblas
    CHECK_RESULT $? 0 0 'sampleblas file not found'
    ./sampleblas| grep '\-4.950000 10.050000 -0.950000 10.050000 -9.950000 4.050000 7.050000 4.050000 5.050000'
    CHECK_RESULT $? 0 0 'Script returned information error'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf sampleblas
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}
main "$@"
