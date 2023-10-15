#!/usr/bin/bash
# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   huike
# @Contact   :   754873891@qq.com
# @Date      :   2022/11/20
# @License   :   Mulan PSL v2
# @Desc      :   verify the uasge of scala command
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    DNF_INSTALL scala
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    scalac -Dproperty=value ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -Dproperty failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -X ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check scalac -X failed"
    scalac -bootclasspath ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -bootclasspath failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -classpath ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -classpath failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -d ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -d failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -dependencyfile ./common/test.scala ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -dependencyfile failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -deprecation ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -deprecation failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -encoding UTF-8 ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -encoding failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -explaintypes ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -explaintypes failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -extdirs ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -extdirs failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf Hello* index* package.* classes
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
