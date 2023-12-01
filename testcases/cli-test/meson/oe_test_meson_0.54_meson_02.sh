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
    tar -xvf common/0.54/test_1.tgz&&cd test_1
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    meson configure --sbindir sbin 2>&1 | grep "sbindir"
    CHECK_RESULT $? 0 0 "meson-configure --sbindir SBINDIR failed"
    meson configure --sharedstatedir com 2>&1 | grep "sharedstatedir"
    CHECK_RESULT $? 0 0 "meson-configure  --sharedstatedir SHAREDSTATEDIR  failed"
    meson configure --sysconfdir etc 2>&1 | grep "sysconfdir"
    CHECK_RESULT $? 0 0 "meson-configure --sysconfdir SYSCONFDIR failed"
    meson configure --auto-features enabled 2>&1 | grep "auto"
    CHECK_RESULT $? 0 0 "meson-configure --auto-features failed"
    meson configure --backend ninja 2>&1 | grep "backend"
    CHECK_RESULT $? 0 0 "meson-configure --backend failed"
    meson configure --buildtype plain 2>&1 | grep "buildtype"
    CHECK_RESULT $? 0 0 "meson-configure --buildtype failed"
    meson configure --debug 2>&1 | grep "debug"
    CHECK_RESULT $? 0 0 "meson-configure --debug failed"
    meson configure --default-library shared 2>&1 | grep "default"
    CHECK_RESULT $? 0 0 "meson-configure --default-library failed"
    meson configure --errorlogs 2>&1 | grep "errorlogs"
    CHECK_RESULT $? 0 0 "meson-configure --errorlogs failed"
    meson configure --install-umask 022 2>&1 | grep "install"
    CHECK_RESULT $? 0 0 "meson-configure --install-umask failed"
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