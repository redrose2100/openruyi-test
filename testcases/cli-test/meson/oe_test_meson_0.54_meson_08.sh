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
#@Desc          :   Test meson-introspect
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.54/test_1.tgz&&cd test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson introspect --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-introspect --help failed"
    meson introspect -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-introspect -h failed"
    cd ./builddir
    meson introspect --benchmark 2>&1 | grep "\[]"
    CHECK_RESULT $? 0 0 "meson-introspect --benchmarks failed"
    meson introspect --buildoptions 2>&1 | grep "name"
    CHECK_RESULT $? 0 0 "meson-introspect --buildoptions failed"
    meson introspect --buildsystem-files 2>&1 | grep "root"
    CHECK_RESULT $? 0 0 "meson-introspect  --buildsystem-files failed"
    meson introspect --dependencies 2>&1 | grep "\[]"
    CHECK_RESULT $? 0 0 "meson-introspect  --dependencies failed"
    meson introspect --scan-dependencies 2>&1 | grep "No command specified"
    CHECK_RESULT $? 0 0 "meson-introspect --scan-dependencies failed"
    meson introspect --installed 2>&1 | grep 'test_1'
    CHECK_RESULT $? 0 0 "meson-introspect --installed BUILDDIR failed"
    meson introspect --projectinfo 2>&1 | grep 'version'
    CHECK_RESULT $? 0 0 "meson-introspect --projectinfo failed"
    meson introspect --targets 2>&1 | grep 'subproject'
    CHECK_RESULT $? 0 0 "meson-introspect --targets failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ../../test_1
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"