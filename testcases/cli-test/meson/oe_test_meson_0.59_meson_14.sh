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
#@Desc          :   Test meson-setup
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson tar gcc"
    tar -xvf common/0.59/test_2.tgz&&cd test_2/builddir
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson setup --reconfigure --layout mirror 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-setup --layout failed"
    meson setup --reconfigure --optimization 0 2>&1 | grep "C compiler"
    CHECK_RESULT $? 0 0 "meson-setup --optimization failed"
    meson setup --reconfigure --stdsplit 2>&1 | grep "Host machine cpu family"
    CHECK_RESULT $? 0 0 "meson-setup --stdsplit failed"
    meson setup --reconfigure --strip 2>&1 | grep "Host machine cpu"
    CHECK_RESULT $? 0 0 "meson-setup --strip failed"  
    meson setup --reconfigure --unity off 2>&1 | grep "Build targets in project"
    CHECK_RESULT $? 0 0 "meson-setup --unity failed"
    meson setup --reconfigure --unity-size 4 2>&1 | grep "Host machine cpu family"
    CHECK_RESULT $? 0 0 "meson-setup --unity-size UNITY_SIZE failed"
    meson setup --reconfigure --warnlevel 3 2>&1 | grep "C compiler"
    CHECK_RESULT $? 0 0 "meson-setup --warnlevel failed"
    meson setup --reconfigure --werror 2>&1 | grep "Build dir:"
    CHECK_RESULT $? 0 0 "meson-setup --werror failed"
    meson setup --reconfigure --wrap-mode default 2>&1 | grep "ninja"
    CHECK_RESULT $? 0 0 "meson-setup --wrap-mode failed" 
    meson setup --reconfigure --pkg-config-path /root 2>&1 | grep "Host machine cpu"
    CHECK_RESULT $? 0 0 "meson-setup --pkg-config-path failed" 
    LOG_INFO "Finish test!"

}

function post_test()
{    
    LOG_INFO "Start to restore the test environment."
    rm -rf ../../test_2
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"