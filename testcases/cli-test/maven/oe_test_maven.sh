#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   fire-kylin
#@Contact   	:   sugarkylin@foxmail.com
#@Date      	:   2021-08-19
#@License   	:   Mulan PSL v2
#@Version   	:   1.0
#@Desc      	:   command test maven
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test()
{
    LOG_INFO "Start to prepare the test environment."
    if java -version; then
        DNF_INSTALL "maven"
    else
        DNF_INSTALL "maven java-11-openjdk"
    fi
    tar -xzvf maven-hello.tar.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test()
{
    LOG_INFO "Start to run test."
    mvn -v
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn -v"
    cd ./maven-hello
    mvn validate
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn validate"
    mvn initialize
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn initialize"
    mvn generate-sources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn generate-sources"
    mvn process-sources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn process-sources"
    < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'
    CHECK_RESULT $? 0 0 "log message: Failed to run command: < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn generate-resources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: "
    < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'
    CHECK_RESULT $? 0 0 "log message: Failed to run command: < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn process-resources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: "
    < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'
    CHECK_RESULT $? 0 0 "log message: Failed to run command: < ./target/classes/META-INF/build-info.properties grep -E 'build.artifact=maven-hello|build.group=com.itranswarp.learnjava|build.name=hello|build.time=*|build.version=1.0-SNAPSHOT'"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn clean compile
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean compile"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn process-classes
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn process-classes"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn generate-test-sources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn generate-test-sources"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn process-test-sources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn process-test-sources"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn generate-test-resources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn generate-test-resources"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn process-test-resources
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn process-test-resources"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn test-compile
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn test-compile"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn process-test-classes
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn process-test-classes"
    mvn clean test
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean test"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn prepare-package
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn prepare-package"
    mvn clean package
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean package"
    java -jar target/maven-hello-1.0-SNAPSHOT.jar
    CHECK_RESULT $? 0 0 "log message: Failed to run command: java -jar target/maven-hello-1.0-SNAPSHOT.jar"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn pre-integration-test
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn pre-integration-test"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn integration-test
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn integration-test"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn post-integration-test
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn post-integration-test"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn verify
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn verify"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn install
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn install"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn pre-clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn pre-clean"
    mvn clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn clean"
    mvn post-clean
    CHECK_RESULT $? 0 0 "log message: Failed to run command: mvn post-clean"
    LOG_INFO "End to run test."
}

function post_test()
{
    LOG_INFO "Start to restore the test environment."
    cd .. && rm -rf ./maven-hello
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
