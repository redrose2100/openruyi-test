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
    fsc -no-specialization ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -no-specialization failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -nobootcp ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -nobootcp failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -nowarn ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -nowarn failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -optimise ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -optimise failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -print ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc -print failed"
    fsc -sourcepath ./ ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -sourcepath failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -target:jvm-1.6 ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc target failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -unchecked ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -unchecked failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -uniqid ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -uniqid failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -usejavacp ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -usejavacp failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf classes Hello* index* package*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
