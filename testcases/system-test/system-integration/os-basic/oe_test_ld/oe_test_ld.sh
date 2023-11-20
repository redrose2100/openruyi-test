#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2023-11-20
# @License   :   Mulan PSL v2
# @Desc      :   ld command test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    which gcc &> /dev/null || DNF_INSTALL "gcc"
    which ld &> /dev/null || DNF_INSTALL "binutils"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    for i in rf1 f1 rd1 d1 main; do
	gcc -fPIC -c -o ${i}.o ./data/${i}.c
        CHECK_RESULT "$?" 0 0 "faild to generate object file: ${i}.o"
    done
    LOG_INFO "Start to run test."
    ld a.o b.o 2>&1 | grep "No such file or directory"
    CHECK_RESULT "$?" 0 0 "Missing file not report."
    ld -shared f1.o d1.o -o test.so
    file test.so | grep -q -e "pie executable" -e "shared object"
    CHECK_RESULT $? 0 0 "Shared library build failed."
    ld -Bdynamic -shared f1.o d1.o -o test.so
    CHECK_RESULT $? 0 0 "Shared library build failed with -Bdynamic"
    ld -Bstatic -L. main.o rd1.o test.so -o a.out
    CHECK_RESULT $? 0 1 "Static link of dynamic object succeed unexpectly."
    ld -Bdynamic -shared main.o f1.o rf1.o -o test.so -L/usr/lib/
    CHECK_RESULT $? 0 0 "Shared library build failed with -Bdynamic"
    ld -Bstatic -r main.o f1.o rf1.o test.so -L/usr/lib/
    CHECK_RESULT $? 0 1 "Static link of dynamic object succeed unexpectly."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf ./*.o
    rm -rf ./test.so
    LOG_INFO "End to restore the test environment."
}

main "$@"
