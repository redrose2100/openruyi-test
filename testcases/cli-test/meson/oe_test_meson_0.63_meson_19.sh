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
#@Contact       :   1140934993@qq.com
#@Date          :   2022-09-06
#@License       :   Mulan PSL v2
#@Desc          :   Test meson test
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc cmake g++"
    cd ./common/0.63/
    tar -xvf '1 basic.tgz'&&cd ./'1 basic' 
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start testing..."
    meson setup --reconfigure builddir
    cd ./builddir
    meson test --no-stdsplit 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --no-stdsplit failed"
    meson test --print-errorlogs 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --print-errorlogs failed"
    meson test --benchmark 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --benchmark failed"
    meson test --benchmark bench --logbase 222
    CHECK_RESULT $? 0 0 "meson test --benchmark failed"
    meson test --num-processes 1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --num-processes failed"
    meson test --verbose 2>&1 | grep "ninja" 
    CHECK_RESULT $? 0 0 "meson test --verbose failed"
    meson test -v 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test -v failed"
    meson test --quiet 2>&1 | grep "ninja"  
    CHECK_RESULT $? 0 0 "meson test --quiet  failed"
    meson test -q 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test -q failed"
    meson test --timeout-multiplier 2 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --timeout-multiplier failed"
    meson test --setup worksforall 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --setup failed"
    meson test --test-args TEST_ARGS 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson test --test-args failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd ../../
    rm -rf ./1\ basic/
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
