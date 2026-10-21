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
    mkdir classes
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    fsc -ipv4 ./common/HelloWorld.scala -d classes
    ps -ef | grep "Dscala.usejavacp=true scala.tools.nsc.MainGenericRunner -Djava.net.preferIPv4Stack=true scala.tools.nsc.CompileServer" | grep -v grep | awk '{print $2}'
    CHECK_RESULT $? 0 0 "Check fsc -ipv4 failed"
    fsc -max-idle 10 ./common/HelloWorld.scala -d classes 2>&1 | grep 'Setting idle timeout to'
    CHECK_RESULT $? 0 0 "Check test -max-idle failed"
    fsc -port 10 ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check test -port failed"
    fsc -reset ./common/HelloWorld.scala -d classes | grep 'Compile server was reset'
    CHECK_RESULT $? 0 0 "Check test -reset failed"
    fsc -port 8888  -max-idle 0 -ipv4 common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check test -port failed"
    fsc -server 127.0.0.1:8888 common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check test -reset failed"
    fsc -Dproperty=10 ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check test -Dproperty failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -X ./common/HelloWorld.scala 2>&1 | grep 'Usage: fsc '
    CHECK_RESULT $? 0 0 "Check fsc -X failed"
    fsc -bootclasspath ./ ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -bootclasspath failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -classpath ./ ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -classpath failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -d ./ ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -d failed"
    rm -rf ./classes/Hello*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -shutdown ./common/HelloWorld.scala | grep 'Compile server exited'
    CHECK_RESULT $? 0 0 "Check fsc -shutdown failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf classes Hello* index* package*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
