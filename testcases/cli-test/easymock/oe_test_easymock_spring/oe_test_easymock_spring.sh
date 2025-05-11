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
# @Desc      :   Easymock combined with spring to simulate an unimplemented class
# ############################################

source "${OET_PATH}/testcases/cli-test/easymock/common/common_easymock.sh"
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "springframework springframework-beans springframework-context"
    deploy_env
    spring_version=$(rpm -q springframework | grep -oP '\d+\.\d+\.\d+' | head -n1)
    maven_version="${spring_version}.RELEASE"
    mkdir -p lib
    wget --no-check-certificate --no-verbose -P lib https://repo1.maven.org/maven2/org/springframework/spring-test/"${maven_version}"/spring-test-"${maven_version}".jar
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    javac -classpath /usr/share/java/*:/usr/share/java/hamcrest/*:/usr/share/java/springframework/*:/usr/share/java/cglib/*:/usr/share/java/objenesis/*:lib/* -d . OtherClass.java OurClass.java OurClassTest.java
    CHECK_RESULT $?
    java -classpath .:/usr/share/java/*:/usr/share/java/hamcrest/*:/usr/share/java/springframework/*:/usr/share/java/cglib/*:/usr/share/java/objenesis/*:lib/* org.junit.runner.JUnitCore OurClassTest | grep "OK (1 test)"
    CHECK_RESULT $?
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf lib/*
    clear_env "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
