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
    scaladoc -verbose ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -verbose failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -version 2>&1 | grep $(rpm -q scala --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check scaladoc -version  failed"
    scaladoc -doc-no-compile ./common/HelloWorld.scala ./common/HelloWorld.scala 2>&1 | grep 'model contains'
    CHECK_RESULT $? 0 0 "Check scaladoc -doc-no-compile failed"
    scaladoc -implicits-hide:./ -implicits-hide doc ./common/HelloWorld.scala && test -f ./index.js
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Check scaladoc -save failed"
    scaladoc -javabootclasspath .:$(find /usr/lib/jvm -name rt.jar 2>&1 | awk 'NR==1'):$(find /usr/share/java/ -name scala-library.jar 2>&1 | awk 'NR==1') ./common/HelloWorld.scala 2>&1 | grep 'model contains'
    CHECK_RESULT $? 0 0 "Check scaladoc -save failed"
    scaladoc @./common/argumentFile ./common/HelloWorld.scala 2>&1 | grep 'model contains'
    CHECK_RESULT $? 0 0 "Check scaladoc @ failed"
    scaladoc -target:jvm-1.6 ./common/HelloWorld.scala 2>&1 | grep 'model'
    CHECK_RESULT $? 0 0 "Check scaladoc -target failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf Hello* index* package.* scala-library.jar classes
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
