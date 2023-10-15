#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   sunqingwei
# @Contact   :   sunqingwei@uniontech.com
# @Date      :   2023/04/12
# @License   :   Mulan PSL v2
# @Desc      :   package aws-sdk-java test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
  LOG_INFO "Start to prepare the test environment."
  DNF_INSTALL "aws-sdk-java"
  mkdir /tmp/test
  LOG_INFO "End to prepare the test environment."
}

function run_test() {
  LOG_INFO "Start testing..."
  cp AwsSdkTest.java /tmp/test
  cd /tmp/test
  javac -cp .:/usr/share/java/aws-sdk-java/aws-java-sdk-core.jar:/usr/share/java/aws-sdk-java/aws-java-sdk-s3.jar:/usr/share/java/aws-sdk-java/aws-java-sdk-kms.jar AwsSdkTest.java
  test -e AwsSdkTest.class
  CHECK_RESULT $? 0 0 "Compilation failure"
  java -cp .:/usr/share/java/aws-sdk-java/aws-java-sdk-core.jar:/usr/share/java/aws-sdk-java/aws-java-sdk-s3.jar:/usr/share/java/aws-sdk-java/aws-java-sdk-kms.jar:/usr/share/java/commons-logging.jar:/usr/share/java/jackson-core.jar:/usr/share/java/jackson-databind.jar:/usr/share/java/jackson-annotations.jar:/usr/share/java/httpcomponents/httpclient.jar:/usr/share/java/httpcomponents/httpcore.jar:/usr/share/java/joda-time.jar AwsSdkTest bucket1 > result.txt
  grep 'Finish kms test!' result.txt
  CHECK_RESULT $? 0 0 "Test failure"
  LOG_INFO "Finish test!"
}

function post_test() {
  LOG_INFO "Start to restore the test environment."
  DNF_REMOVE
  rm -rf /tmp/test
  LOG_INFO "End to restore the test environment."
}

main $@

