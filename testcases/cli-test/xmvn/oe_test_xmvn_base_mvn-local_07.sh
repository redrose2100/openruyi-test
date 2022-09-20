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
    mvn --non-recursive test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --non-recursive error.'
    mvn --no-plugin-registry test|grep "deprecated"
    CHECK_RESULT $? 0 0 'option --no-plugin-registry error.'
    mvn --no-plugin-updates test|grep "deprecated"
    CHECK_RESULT $? 0 0 'option --no-plugin-updates error.'
    mvn clean install --no-snapshot-updates|grep "Changes detected"
    CHECK_RESULT $? 0 0 'option --no-snapshot-updates error.'
    mvn --offline test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --offline error.'
    mvn --activate-profiles settings  test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --activate-profiles error.' 
    cd ../maven-parent-master
    mvn -projects org.apache.maven.extensions:maven-extensions clean install -am|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option -projects error.' 
    cd ../my-app  
    mvn --quiet testtest | grep "ERROR"
    CHECK_RESULT $? 1 1 'option --quiet error.'
    mvn --resume-from ./ test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --resume-from error.'
    mvn --settings settings.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --settings error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    LOG_INFO "End to restore the test environment."
}

main "$@"
