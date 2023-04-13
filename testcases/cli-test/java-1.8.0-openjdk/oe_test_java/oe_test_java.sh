#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   xiechangyan1
# @Contact   :   xiechangyan@uniontech.com
# @Date      :   2023-04-12
# @License   :   Mulan PSL v2
# @Desc      :   Use java case
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "java-1.8.0-openjdk java-1.8.0-openjdk-devel"
    pwd=`pwd`
    mkdir java_test && cd java_test
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    cat > HelloWorld.java << EOF
public class HelloWorld {
public static void main(String[] args) {
System.out.println("Hello, World");
}
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create HelloWorld.java"
    javac HelloWorld.java
    CHECK_RESULT $? 0 0 "Error,fail to create helloworld"
    java HelloWorld | grep  "Hello, World"
    CHECK_RESULT $? 0 0 "Error,Check the content of the 'Java' installation package or 'helloworld' file"

    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    cd $pwd && rm -rf java_test
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"