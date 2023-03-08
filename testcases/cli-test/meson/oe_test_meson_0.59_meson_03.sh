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
#@Desc          :   Test meson-configure
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
    meson configure --layout mirror 2>&1 | grep "layout"
    CHECK_RESULT $? 0 0 "meson-configure --layout failed"
    meson configure --optimization 0 2>&1 | grep "optimization"
    CHECK_RESULT $? 0 0 "meson-configure --optimization failed"
    meson configure --stdsplit 2>&1 | grep "stdsplit"
    CHECK_RESULT $? 0 0 "meson-configure --stdsplit failed"
    meson configure --strip 2>&1 | grep "strip"
    CHECK_RESULT $? 0 0 "meson-configure --strip failed"
    meson configure --unity off 2>&1 | grep "unity"
    CHECK_RESULT $? 0 0 "meson-configure --unity failed"
    meson configure --unity-size 4 2>&1 | grep "unity_size"
    CHECK_RESULT $? 0 0 "meson-configure --unity-size UNITY_SIZE failed"
    meson configure --warnlevel 3 2>&1 | grep "warning_level"
    CHECK_RESULT $? 0 0 "meson-configure --warnlevel failed"
    meson configure --werror 2>&1 | grep "werror"
    CHECK_RESULT $? 0 0 "meson-configure --werror failed"
    meson configure --wrap-mode default 2>&1 | grep "wrap_mode"
    CHECK_RESULT $? 0 0 "meson-configure --wrap-mode failed"
    meson configure --pkg-config-path /root 2>&1 | grep "pkg_config_path"
    CHECK_RESULT $? 0 0 "meson-configure --pkg-config-path PKG_CONFIG_PATH  failed"
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