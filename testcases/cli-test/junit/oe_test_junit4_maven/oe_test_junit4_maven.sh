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
# @Author    :   liujuan
# @Contact   :   lchutian@163.com
# @Date      :   2020/05/20
# @License   :   Mulan PSL v2
# @Desc      :   Junit4+maven integration testing
# ############################################
# shellcheck disable=SC1091,SC2010

source "../common/common_junit.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    deploy_env
    DNF_INSTALL "hamcrest maven"
    cp /etc/profile /etc/profile-bak
    export MAVEN_HOME=/usr/share/maven
    mkdir libs
    cp -r "$(rpm -ql junit | grep junit.jar)" libs
    wget https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar
    mv hamcrest-core-1.3.jar libs/
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mvn test >log
    grep "BUILD SUCCESS" log
    CHECK_RESULT $?
    mvn -Dtest=TestApp2 test >log
    grep "BUILD SUCCESS" log
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    unset MAVEN_HOME
    find . -mindepth 1 -maxdepth 1 ! -name "*.xml" ! -name "main" ! -name "*.sh" ! -name "test" -exec rm -rf {} + && rm -rf /root/.m2
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
