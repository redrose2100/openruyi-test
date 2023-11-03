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
    mvn -pl org.apache.maven.extensions:maven-extensions clean install --also-make|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option -also-make error.'
    mvn -pl org.apache.maven:maven-parent clean install --also-make-dependents|grep "Reactor Build Order"
    CHECK_RESULT $? 0 0 'option --also-make-dependents error.'
    cd ../my-app
    mvn --batch-mode test|grep "SUCCESS"
    CHECK_RESULT $? 0 0 'option --batch-mode error.'
    mvn --builder singlethreaded test|grep "SUCCESS"
    CHECK_RESULT $? 0 0 'option --builder error.'
    mvn --strict-checksums test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option --strict-checksums error.'
    mvn --lax-checksums test|grep "BUILD SUCCESS"
    CHECK_RESULT $? 0 0 'option ---lax-checksums error.'
    mvn --check-plugin-updates test|grep "deprecated"
    CHECK_RESULT $? 0 0 'option --check-plugin-updates error.'
    mvn clean install --define maven.test.skip|grep "Tests are skipped"
    CHECK_RESULT $? 0 0 'option --define error.'
    mvn -ssetting.xml --errors test|grep "stacktraces"
    CHECK_RESULT $? 0 0 'option --errors error.'
    mvn --encrypt-master-password 12345 > result.txt
    test -s result.txt
    CHECK_RESULT $? 0 0 'option --encrypt-master-password error.'
    LOG_INFO "End to run test."
}


function post_test() {
    LOG_INFO "Start to restore the test environment."
    restore
    LOG_INFO "End to restore the test environment."
}

main "$@"
