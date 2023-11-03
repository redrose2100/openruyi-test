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
#@Desc          :   Test meson-install
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.54/test_1.tgz&&cd test_1/builddir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson install --help 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-install --help failed"
    meson install -h 2>&1 | grep "usage: meson"
    CHECK_RESULT $? 0 0 "meson-install  -h failed"
    meson install -C ./
    CHECK_RESULT $? 0 0 "meson-install -C WD failed"
    meson install --no-rebuild 
    CHECK_RESULT $? 0 0 "meson-install --no-rebuild failed"
    meson install --only-changed 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-install --only-changed failed"
    meson install --quiet 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-install --quiet failed"
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