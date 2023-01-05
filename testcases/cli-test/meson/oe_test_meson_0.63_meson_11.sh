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
#@Desc          :   Test meson-rewrite
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc g++"
    tar -xvf common/0.63/test_4.tgz&&cd ./test_4
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson rewrite --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-rewrite --help failed"
    meson rewrite -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-rewrite -h failed"
    meson rewrite -s ./ target trivialprog9 add fileD.cpp
    CHECK_RESULT $? 0 0 "meson-rewrite  -s SRCDIR failed"
    meson rewrite --sourcedir ./ target trivialprog9 add fileD.cpp
    CHECK_RESULT $? 0 0 "meson-rewrite --sourcedir SRCDIR failed"
    meson rewrite --verbose target trivialprog9 add fileB.cpp 2>&1 | grep "Analyzing meson file:"
    CHECK_RESULT $? 0 0 "meson-rewrite  -V or --verbose failed"
    meson rewrite --skip-errors --verbose target trivialprog9 add fileB.cpp 2>&1 | grep "Analyzing meson file:"
    CHECK_RESULT $? 0 0 "meson-rewrite  -S or --skip-errors failed"
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    rm -rf ./../test_4
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"