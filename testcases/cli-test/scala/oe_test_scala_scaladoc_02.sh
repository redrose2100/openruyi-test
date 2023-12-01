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
    scaladoc -doc-source-url http://www.baidu.com ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check scaladoc -doc-source-url  failed"
    scaladoc -doc-title title ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -doc-title failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -doc-version 1.6 ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -doc-version failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -expand-all-types ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -expand-all-types  failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -groups ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -groups failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -implicits ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -implicits  failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -implicits-show-all ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -implicits-show-all failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -no-link-warnings ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -no-link-warnings failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -no-prefixes ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -no-prefixes failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -raw-output ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -raw-output failed"
    rm -rf ./index*
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
