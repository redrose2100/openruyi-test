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
    cd ./common/0.63/
    tar -xvf '1 basic.tgz'  
    cd ./../../
    cp -rf ./common/0.63/'1 basic'   ./   
    cd ./'1 basic' 
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson setup --reconfigure builddir    
    cd ./builddir
    meson test --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson test --help  failed"
    meson test -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson test  -h failed"
    meson test --repeat 2 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --repeat failed"
    meson test --no-rebuild 2>&1 | grep "OK"
    CHECK_RESULT $? 0 0 "meson test --no-rebuild failed"
    meson test --wrap='valgrind --tool=helgrind' test1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --wrap failed"
    meson test --gdb-path gdb 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --gdb-path failed"
    meson test --list 2>&1 | grep "test1"
    CHECK_RESULT $? 0 0 "meson test --list failed"
    meson test -C ./
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
    rm -rf ./1\ basic/
    rm -rf ./common/0.63/'1 basic'
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
