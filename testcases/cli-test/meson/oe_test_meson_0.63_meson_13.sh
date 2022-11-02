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
    meson setup --reconfigure --sbindir sbin 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --sbindir SBINDIR failed"
    meson setup --reconfigure --sharedstatedir com 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --sharedstatedir SHAREDSTATEDIR  failed"
    meson setup --reconfigure --sysconfdir etc 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --sysconfdir SYSCONFDIR failed"
    meson setup --reconfigure --auto-features enabled 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --auto-features failed"
    meson setup --reconfigure --backend ninja 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --backend failed"
    meson setup --reconfigure --buildtype plain 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --buildtype INFODIR failed"
    meson setup --reconfigure --debug 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --debug failed"
    meson setup --reconfigure --default-library shared 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --default-library failed"
    meson setup --reconfigure --errorlogs 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup --errorlogs failed"
    meson setup --reconfigure --install-umask 022 2>&1 | grep "The Meson build system"
    CHECK_RESULT $? 0 0 "meson-setup  --install-umask INSTALL_UMAS failed"
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