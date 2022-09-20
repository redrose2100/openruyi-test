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
    mvn --encrypt-password 12345 > result.txt
    test -s result.txt
    CHECK_RESULT $? 0 0 'option --encrypt-password error.'
    mvn --file pom.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --file error.'
    mvn --fail-at-end test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --fall-at-end error.'
    mvn --fail-fast test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --fail-fast error.'
    cd ../maven-parent-master
    mvn --fail-never test|grep "ignore"
    CHECK_RESULT $? 0 0 'option --fail-never error.'
    cd ../my-app
    mvn --global-settings settings.xml|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --global-settings error.'
    mvn --global-toolchains ./toolchains.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --global-toolchains error.'
    mvn --help|grep "Options"
    CHECK_RESULT $? 0 0 'option --help error.'
    mvn --log-file log.txt
    test -s log.txt
    CHECK_RESULT $? 0 0 'option --log-file error.'
    mvn --legacy-local-repository clean install|grep "Building jar"
    CHECK_RESULT $? 0 0 'option --legacy-local-repository error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    rm -rf result.txt log.txt
    LOG_INFO "End to restore the test environment."
}

main "$@"
