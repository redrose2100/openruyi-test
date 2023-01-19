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
    scaladoc -diagrams-debug ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-debug failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -Dproperty=value ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -Dproperty failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -X ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check scaladoc -X failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -bootclasspath ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -bootclasspath failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -classpath ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -classpath failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -d ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -d  failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -dependencyfile ./common/test.scala ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -dependencyfile failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -deprecation ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -deprecation failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -doc-external-doc:',' ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -doc-external-doc: failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -diagrams-debug ./common/HelloWorld.scala 2>&1 | grep 'Diagram generation'
    CHECK_RESULT $? 0 0 "Check scaladoc -diagrams-debug failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf Hello* index* package.* classes
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
