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
    scalac  ./common/HelloWorld.scala
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start to run test."
    scalap -private Hello
    CHECK_RESULT $? 0 0 "Check scalap -private failed"
    scalap -verbose Hello
    CHECK_RESULT $? 0 0 "Check scalap -verbose failed"
    scalap -version 2>&1 | grep 'Scala classfile decoder version'
    CHECK_RESULT $? 0 0 "Check scalap -version failed"
    scalap -help 2>&1 | grep 'Usage: scalap'
    CHECK_RESULT $? 0 0 "Check scalap -help failed"
    scalap -classpath ./ Hello
    CHECK_RESULT $? 0 0 "Check scalap -classpath failed"
    scalap -cp ./ Hello
    CHECK_RESULT $? 0 0 "Check scalap -cp failed"
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf Hello* index* package.*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
