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
    scaladoc -no-specialization ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc  -no-specialization failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -nobootcp ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc  -nobootcp failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -nowarn ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -nowarn failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -optimise ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -optimise failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -print ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -print failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -sourcepath ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -sourcepath failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -toolcp ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -toolcp failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -unchecked ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -unchecked failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -uniqid ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -uniqid failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -usejavacp ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -usejavacp failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf Hello* index* package.* scala-library.jar classes
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
