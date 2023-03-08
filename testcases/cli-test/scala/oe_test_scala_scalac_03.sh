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
    scalac -target:jvm-1.6 ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -target:jvm-1.6 failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -toolcp ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -toolcp failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -usejavacp ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -usejavacp failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -verbose ./common/HelloWorld.scala 2>&1 | grep 'Generating icode'
    CHECK_RESULT $? 0 0 "Check scalac -verbose failed"
    scalac -version 2>&1 | grep $(rpm -q scala --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check scalac -version failed"
    scalac -javabootclasspath .:$(find /usr/lib/jvm -name rt.jar 2>&1 | awk 'NR==1'):$(find /usr/share/java/ -name scala-library.jar 2>&1 | awk 'NR==1') ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check scalac -save failed"
    scalac -J-Xmx512m ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -J-Xmx512m failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac @./common/argumentFile ./common/HelloWorld.scala && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check scalac @ failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf classes scala-library.jar Hello* index* package*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
