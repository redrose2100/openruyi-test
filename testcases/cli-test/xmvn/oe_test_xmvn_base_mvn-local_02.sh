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
#@Author    	:   Xuan Xiao
#@Contact   	:   xxiao@tiangong.edu.cn
#@Date      	:   2022-10-09 09:39:43
#@License   	:   Mulan PSL v2
#@Desc      	:   Test "mvn" command
#####################################

source "./common/function.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    pretreatment
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    mvn -ep 12345 > result.txt
    test -s result.txt
    CHECK_RESULT $? 0 0 'option -ep error.'
    mvn -f pom.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -f error.'
    mvn -fae test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -fae error.'
    mvn -ff test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -ff error.'
    cd ../maven-parent-master
    mvn -fn test|grep "ignore"
    CHECK_RESULT $? 0 0 'option -fn error.'
    cd ../my-app
    mvn -gs settings.xml|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -gs error.'
    mvn -gt ./toolchains.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -gt error.'
    mvn -h|grep "Options"
    CHECK_RESULT $? 0 0 'option -h error.'
    mvn -l log.txt
    test -s log.txt
    CHECK_RESULT $? 0 0 'option -l error.'
    mvn -llr clean install|grep "Building jar"
    CHECK_RESULT $? 0 0 'option -llr error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    rm -rf result.txt log.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
