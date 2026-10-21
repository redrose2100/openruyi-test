#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
# #############################################
# @Author    :   tangxiaolan
# @Contact   :   tangxiaolan0712@163.com
# @Date      :   2020/5/14
# @License   :   Mulan PSL v2
# @Desc      :   Easymock with JUnit5
# ############################################
# shellcheck disable=SC1091,SC2010

source "../common/common_easymock.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "easymock junit5 maven wget"
    java_version=$(rpm -qa java* | grep "java-.*-openjdk" -m1 | awk -F '-' '{print $2}')
    DNF_INSTALL java-"${java_version}"-devel
    mkdir libs
    cp -rf "$(rpm -ql junit5 | grep junit-jupiter-api.jar)" "$(rpm -ql easymock | grep easymock.jar)" libs
    wget --no-check-certificate https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
    mv hamcrest-core-1.3.jar libs/
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mvn test | grep "Tests run: 1, Failures: 0, Errors: 0, Skipped: 0"$'\n'"BUILD SUCCESS"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    find . -mindepth 1 -maxdepth 1 ! -name "*.xml" ! -name "main" ! -name "*.sh" ! -name "test" -exec rm -rf {} + && rm -rf /root/.m2
    LOG_INFO "End to restore the test environment."
}

main "$@"
