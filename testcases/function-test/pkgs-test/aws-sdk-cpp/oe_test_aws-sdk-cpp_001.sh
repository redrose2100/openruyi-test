#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lukeman
# @Contact   :   lukeman@qq.com
# @Date      :   2025/01/15
# @License   :   Mulan PSL v2
# @Desc      :   package aws-sdk-cpp test
# ############################################
# shellcheck disable=SC1090

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "aws-sdk-cpp g++ aws-sdk-cpp-devel"
    rm -rf /tmp/aws-sdk-cpp-test
    mkdir /tmp/aws-sdk-cpp-test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    rpm -qa | grep aws-sdk-cpp
    CHECK_RESULT $? 0 0 "Return value error."
    cp AwsSdkCppTest.cpp /tmp/aws-sdk-cpp-test/
    cd /tmp/aws-sdk-cpp-test/ || exit
    g++ -D_GLIBCXX_USE_CXX11_ABI=0 AwsSdkCppTest.cpp -o AwsSdkCppTest -laws-cpp-sdk-core -laws-cpp-sdk-s3
    test -e AwsSdkCppTest
    CHECK_RESULT $? 0 0 "Compilation failure"
    ./AwsSdkCppTest bucket1 > result.txt
    grep 'Finish AWS test!' result.txt
    CHECK_RESULT $? 0 0 "Test failure."
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf /tmp/aws-sdk-cpp-test
    LOG_INFO "End to restore the test environment."
}

main "$@"
