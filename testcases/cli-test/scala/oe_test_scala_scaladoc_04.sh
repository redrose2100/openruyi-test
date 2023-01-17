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
    scaladoc -encoding UTF-8 ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -encoding failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -explaintypes ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -explaintypes failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -extdirs ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -extdirs failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -external-urls:',' ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -external-urls: failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -feature ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -feature  failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -g:none ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -g:none failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -implicits-sound-shadowing ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc  -implicits-sound-shadowing failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -javaextdirs ./ ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc javaextdirs failed"
    rm -rf ./index*
    CHECK_RESULT $? 0 0 "Delete test file failed"
    scaladoc -language:one ./common/HelloWorld.scala && test -f ./index.js
    CHECK_RESULT $? 0 0 "Check scaladoc -language:one failed"
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
