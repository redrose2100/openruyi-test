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
    scalac -feature ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -feature failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -g:none ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -g:none failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -help 2>&1 | grep 'Usage: scalac '
    CHECK_RESULT $? 0 0 "Check scalac -help failed"
    scalac -javaextdirs ./ ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -javaextdirs failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -language:one ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -language:one failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -no-specialization ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -no-specialization failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -nobootcp ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -nobootcp failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -optimise ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac -optimise failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scalac -print ./common/test.scala | grep 'object Hello extends'
    CHECK_RESULT $? 0 0 "Check scalac -print failed"
    scalac -sourcepath ./ ./common/test.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check scalac sourcepath failed"
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
