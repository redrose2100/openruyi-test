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
    fsc -verbose ./common/HelloWorld.scala 2>&1 | grep 'Fast Scala compiler'
    CHECK_RESULT $? 0 0 "Check fsc -verbose failed"
    fsc -version fsc -version | grep $(rpm -q scala --queryformat '%{version}\n')
    CHECK_RESULT $? 0 0 "Check fsc -version failed"
    fsc -port 18888 ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc -port failed"
    ps -ef | grep "Dscala.usejavacp=true scala.tools.nsc.MainGenericRunner scala.tools.nsc.CompileServer -p 18888" | grep -v grep | awk '{print $2}'
    CHECK_RESULT $? 0 0 "Check fsc -port failed"
    fsc -server 127.0.0.1:18888 ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc -server failed"
    fsc @./common/argumentFile ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc @ failed"
    fsc -toolcp $(find /usr/share/java/ -name scala-library.jar 2>&1 | awk 'NR==1') ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc -toolcp failed"
    fsc -J-Xmx512m ./common/HelloWorld.scala && test -f ./Hello.class
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -toolcp failed"
    fsc -javabootclasspath .:$(find /usr/lib/jvm -name rt.jar 2>&1 | awk 'NR==1'):$(find /usr/share/java/ -name scala-library.jar 2>&1 | awk 'NR==1') ./common/HelloWorld.scala
    CHECK_RESULT $? 0 0 "Check fsc -javabootclasspath failed"
    fsc -P:silly:level:12 ./common/HelloWorld.scala
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    fsc -P:silly:level:12 ./common/HelloWorld.scala && test -f ./Hello.class
    CHECK_RESULT $? 0 0 "Check fsc -P failed"
    rm -rf ./Hello.class
    CHECK_RESULT $? 0 0 "Delete test file failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf silly.jar classes Hello* index* package*
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
