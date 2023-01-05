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
#@Desc          :   Test meson-dist
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc git"
    cd common/0.54
    tar -xvf soname.tgz&&cd '1 soname'
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson setup --reconfigure builddir
    meson dist --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-dist --help failed"
    meson dist -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-dist -h failed"
    meson dist -C builddir 2>&1 | grep "Build targets in project"
    CHECK_RESULT $? 0 0 "meson-dist --C failed"
    meson dist -C builddir --formats xztar 2>&1 | grep "Build targets in project"
    CHECK_RESULT $? 0 0 "meson-dist --formats FORMATS failed"
    meson dist -C builddir --include-subprojects 2>&1 | grep "Testing distribution package"
    CHECK_RESULT $? 0 0 "meson-dist --include-subprojects failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ../'1 soname'
    LOG_INFO "End to restore the test environment."
}

main "$@"