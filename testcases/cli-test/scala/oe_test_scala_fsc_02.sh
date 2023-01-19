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
    fsc -dependencyfile ./common/test.scala ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -dependencyfile failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -deprecation ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -deprecation failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -encoding UTF-8 ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -encoding failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -explaintypes ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -explaintypes failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -extdirs ./ ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -extdirs failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -feature ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -feature failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -g:none ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -g:none failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -help 2>&1 | grep 'Usage: fsc '
    CHECK_RESULT $? 0 0 "Check fsc -help failed"
    fsc -javaextdirs ./ ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -javaextdirs failed"
    rm -rf ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -language:one ./common/HelloWorld.scala -d classes && test -f ./classes/Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -language:one failed"
    rm -rf ./classes/Hello.class
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
