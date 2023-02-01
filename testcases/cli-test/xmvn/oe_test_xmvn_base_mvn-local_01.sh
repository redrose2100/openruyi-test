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
    cd ../maven-parent-master
    mvn -pl org.apache.maven.extensions:maven-extensions clean install -am|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option -am error.'
    mvn -pl org.apache.maven:maven-parent clean install -amd|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option -amd error.'
    cd ../my-app
    mvn -B test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -B error.'
    mvn -b singlethreaded test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -b error.'
    mvn -C test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -C error.'
    mvn -c test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -c error.'
    mvn -cpu test|grep "cpu is deprecated"
    CHECK_RESULT $? 0 0 'option -cpu error.'
    mvn clean install -D maven.test.skip|grep "Tests are skipped"
    CHECK_RESULT $? 0 0 'option -D error.'
    mvn -s setting.xml -e test|grep "stacktraces"
    CHECK_RESULT $? 0 0 'option -e error.'
    mvn -emp 12345 > result.txt
    test -s result.txt
    CHECK_RESULT $? 0 0 'option -emp error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    rm -rf result.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
