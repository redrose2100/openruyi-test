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
#@Contact       :   1048074322@@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-setup
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "meson"
    cd ./common/0.63/
    tar -xvf test_1.tgz
    cd ./../../
    cp -rf ./common/0.63/test_1 ./
    cd ./test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    cd ./builddir
    meson setup --reconfigure --cmake-prefix-path /root 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --cmake-prefix-path CMAKE_PREFIX_PATH failed"
    meson setup --reconfigure --build.cmake-prefix-path /root 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --build.cmake-prefix-path BUILD.CMAKE_PREFIX_PATH failed"
    meson setup --reconfigure -D =1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup -D option failed"
    cd ..
    meson setup --reconfigure --wipe builddir 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --wipe failed"
    cd ./builddir
    meson setup --reconfigure --force-fallback-for subproject 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --force-fallback-for FORCE_FALLBACK_FOR failed"
    meson setup --reconfigure --build.pkg-config-path /root 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup  --build.pkg-config-path BUILD.PKG_CONFIG_PATH failed"
    cd ..
    meson setup --reconfigure --native-file NATIVE_FILE.txt --reconfigure builddir 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --native-file NATIVE_FILE failed"
    meson setup --reconfigure --cross-file CROSS_FILE.txt --reconfigure builddir 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --cross-file CROSS_FILE failed"
    cd ./builddir
    meson setup --reconfigure --fatal-meson-warnings 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --fatal-meson-warnings failed"
    meson setup --reconfigure 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --reconfigure failed"
    meson setup --version 2>&1 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "meson-setup  -v or --version failed"
    LOG_INFO "Finish test!"
}

function post_test()
{    
    LOG_INFO "Start to restore the test environment."
    rm -rf ./../../test_1
    rm -rf ./../../common/0.63/test_1
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"