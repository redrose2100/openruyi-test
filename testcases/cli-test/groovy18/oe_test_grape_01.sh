#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   朱文硕
# @Contact   :   1003254035@qq.com
# @Date      :   2023/03/21
# @License   :   Mulan PSL v2
# @Desc      :   Test grape
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "groovy18 tar"
    tar -xvf common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    grape18 install  com.jcraft jzlib 1.1.3 | grep "SUCCESSFUL"
    CHECK_RESULT $? 0 0 "Check grape install failed"
    grape18 list  | grep "com.jcraft"
    CHECK_RESULT $? 0 0 "Check grape list failed"
    grape18 uninstall  com.jcraft jzlib 1.1.3 | grep "Deleting jzlib-1.1.4"
    CHECK_RESULT $? 0 0 "Check grape uninstall failed"
    grape18 install  com.jcraft jzlib 1.1.3
    grape18 resolve  com.jcraft jzlib 1.1.3 | grep "jzlib-1.1.3.jar"
    CHECK_RESULT $? 0 0 "Check grape resolve failed"
    grape18 --help | grep "usage: grape"
    CHECK_RESULT $? 0 0 "Check grape --help failed"
    grape18 -h | grep "usage: grape"
    CHECK_RESULT $? 0 0 "Check grape -h failed"
    grape18 -v | grep "Groovy Version:"
    CHECK_RESULT $? 0 0 "Check grape -v failed"
    grape18 --version | grep "Groovy Version:"
    CHECK_RESULT $? 0 0 "Check grape --version failed"
    grape18 -D=name="jack" list | grep "jzlib"
    CHECK_RESULT $? 0 0 "Check grape -D failed"
    grape18 --define=name="jack" list | grep "jzlib"
    CHECK_RESULT $? 0 0 "Check grape --define failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
