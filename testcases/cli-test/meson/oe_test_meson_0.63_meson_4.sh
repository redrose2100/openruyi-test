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
#@Author        :   liuzhaoda
#@Contact       :   1048074322@@qq.com
#@Date          :   2022-08-17
#@License       :   Mulan PSL v2
#@Desc          :   Test meson-configure
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function pre_test()
{
    LOG_INFO "Start to prepare the test environment."

    DNF_INSTALL "meson"

    cp -rf ./common/0.63/test_1 ./

    cd ./test_1

    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."

    meson configure --cmake-prefix-path /root 2>&1 | grep "cmake_prefix_path"
    CHECK_RESULT $? 0 0 "meson-configure --cmake-prefix-path failed"

    meson configure --build.cmake-prefix-path /root 2>&1 | grep "build.cmake_prefix_path"
    CHECK_RESULT $? 0 0 "meson-configure --build.cmake-prefix-path BUILD.CMAKE_PREFIX_PATH  failed"
    
    meson configure -D =1 | grep "D"
    CHECK_RESULT $? 0 0 "meson-configure -D option failed"
    
    meson configure --clearcache 2>&1 | grep "Main project options:"
    CHECK_RESULT $? 0 0 "meson-configure --clearcache failed"

    meson configure --build.pkg-config-path /root 2>&1 | grep "build.pkg_config_path"
    CHECK_RESULT $? 0 0 "meson-configure --build.pkg-config-path BUILD.PKG_CONFIG_PATH failed"
    
    meson configure --force-fallback-for subproject 2>&1 | grep "force_fallback_for"
    CHECK_RESULT $? 0 0 "meson-configure --force-fallback-for FORCE_FALLBACK_FOR failed"
    
    LOG_INFO "Finish test!"
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."

    rm -rf ./../test_1

    DNF_REMOVE

    LOG_INFO "End to restore the test environment."
}

main "$@"