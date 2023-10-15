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
    mvn --toolchains ./toolchains.xml test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --toolchains error.'
    mvn --threads 9219 test|grep "MultiThreadedBuilder"
    CHECK_RESULT $? 0 0 'option --threads error.'
    mvn --update-snapshots test|grep "Building my-app 1.0-SNAPSHOT"
    CHECK_RESULT $? 0 0 'option --update-snapshots error.'
    mvn -update-plugins test|grep "deprecated"
    CHECK_RESULT $? 0 0 'option -update-plugins error.'
    mvn --version|grep "version"
    CHECK_RESULT $? 0 0 'option --version error.'
    mvn --show-version test|grep "version"
    CHECK_RESULT $? 0 0 'option --show-version error.'
    mvn --debug test|grep "DEBUG"
    CHECK_RESULT $? 0 0 'option --debug error.'
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    LOG_INFO "End to restore the test environment."
}

main "$@"
