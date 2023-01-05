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
#@Desc          :   Test meson-init
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.59/test_1.tgz&&cd test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson init --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-init --help failed"
    meson init -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-init -h failed"
    meson init -C ./ 2>&1 | grep "test_1"
    CHECK_RESULT $? 0 0 "meson-init -C"
    meson init -n testproject 2>&1 | grep "testproject"
    CHECK_RESULT $? 0 0 "meson-init -n NAME failed"
    meson init --name testproject 2>&1 | grep "testproject"
    CHECK_RESULT $? 0 0 "meson-init --name NAME failed"
    meson init -e testproject 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init -e EXECUTABLE EXECUTABLE failed"
    meson init --executable testproject 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --executable EXECUTABLE failed"
    meson init -d deps 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init  -d DEPS failed"
    meson init --deps deps 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --deps DEPS failed"
    meson init -l c 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init  -l failed"
    meson init --language c 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --language failed"
    meson init -b c 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init -b failed"
    meson init --build c 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --build failed"
    meson init --builddir builddir 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --builddir BUILDDIR failed"
    meson init -f 2>&1 | grep "executable"
    CHECK_RESULT $? 0 0 "meson-init -f failed"
    meson init --force 2>&1 | grep "executable"
    CHECK_RESULT $? 0 0 "meson-init --force failed"
    meson init --type executable 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --type failed"
    meson init --version 0.1 2>&1 | grep "Using"
    CHECK_RESULT $? 0 0 "meson-init --version VERSION failed"
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