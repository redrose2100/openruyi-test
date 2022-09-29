#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   yuyi
#@Contact       :   1140934993@@qq.com
#@Date          :   2022-09-04
#@License       :   Mulan PSL v2
#@Desc          :   Test meson test
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "meson"

    cp -rf ./common/0.54/test_5/2\ testsetups/ ./

    cd ./2\ testsetups/

    # cp ./common/distances_test.xml ./tmp ###! ./common/distances_test.xml ./ dame
    # cp ./common/input_test.xml ./tmp     ###! {OET_PATH}/testcases/cli-test/common/input_test.xml ./

    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    dnf install valgrind
    cd ./builddir
    meson test --help 2>&1 | grep "usage: meson" 
    CHECK_RESULT $? 0 0 "meson test --help failed"
    meson test -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson test -h failed"
    meson test --repeat 2 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --repeat failed"
    meson test --no-rebuild 2>&1 | grep "1/2 testsetups"
    CHECK_RESULT $? 0 0 "meson test --no-rebuild failed"
    meson test --wrap='valgrind --tool=helgrind' test1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --wrap failed"
    meson test --gdb-path gdb 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --gdb-path failed"
    meson test --list 2>&1 | grep "testsetups:"
    CHECK_RESULT $? 0 0 "meson test --list failed"

    meson test -C ./ 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test -C WD failed"
    meson test --suite foo
    CHECK_RESULT $? 0 0 "meson test --suite failed"
    meson test --no-suite test1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --no-suite failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    cd ../../

    rm -rf ./2\ testsetups/

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"
