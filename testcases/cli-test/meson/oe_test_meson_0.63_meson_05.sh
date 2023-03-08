#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   liuzhaoda
#@Contact       :   1048074322@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-compile
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc g++ cmake"
    tar -xvf common/0.63/test_1.tgz&&cd test_1
    rm -rf builddir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson setup builddir
    meson compile --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-compile --help failed"
    meson compile -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-compile -h failed"
    meson compile -C builddir --clean 2>&1 | grep "Cleaning"
    CHECK_RESULT $? 0 0 "meson-compile --clean failed"
    meson compile -C builddir 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile --C BUILDDIR failed"
    meson compile -C builddir -j 1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile -j JOBS failed"
    meson compile -C builddir --jobs 1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile -j JOBS or --jobs JOBS failed"
    meson compile -C builddir -l 1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile -l LOAD_AVERAGE failed"
    meson compile -C builddir --load-average 1 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile --load-average LOAD_AVERAGE failed"
    meson compile -C builddir -v 2>&1 | grep "ninja" 
    CHECK_RESULT $? 0 0 "meson-compile -v failed"
    meson compile -C builddir --verbose 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile --verbose failed"
    meson compile -C builddir --ninja-args=-n,-d,explain 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-compile --ninja-args NINJA_ARGS failed"
    meson compile -C builddir --vs-args=-n,-d,explain
    CHECK_RESULT $? 0 0 "meson-compile --vs-args VS_ARGS failed"
    meson compile -C builddir --xcode-args=-n,-d,explain
    CHECK_RESULT $? 0 0 "meson-compile --xcode-args XCODE_ARGS failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../test_1
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"