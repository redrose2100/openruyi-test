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
    mvn -N test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -N error.'
    mvn -npr test|grep "npr is deprecated"
    CHECK_RESULT $? 0 0 'option -npr error.'
    mvn -npu test|grep "npu is deprecated"
    CHECK_RESULT $? 0 0 'option -npu error.'
    mvn clean install -nsu|grep "Changes detected"
    CHECK_RESULT $? 0 0 'option -nsu error.'
    mvn -o test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -o error.'
    mvn -P settings test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -P error.'
    cd ../maven-parent-master
    mvn -pl org.apache.maven.extensions:maven-extensions clean install -am|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option -pl error.' 
    cd ../my-app  
    mvn -q  testtest | grep "ERROR"
    CHECK_RESULT $? 1 1 'option -q error.'
    mvn -rf ./ test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -rf error.'
    mvn -s settings.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option -s error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    LOG_INFO "End to restore the test environment."
}

main "$@"
