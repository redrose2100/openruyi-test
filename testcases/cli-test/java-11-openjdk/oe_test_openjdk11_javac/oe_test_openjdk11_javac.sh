#!/usr/bin/bash

#Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-07-14
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../../java-1.8.0-openjdk/common/Hello.java . || exit
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    java -h 2>&1 | grep "用法：java"
    CHECK_RESULT $? 0 0 "java -h failed"
    javac ./Hello.java
    java -cp ./ Hello | grep 'Hello,world!'
    CHECK_RESULT $? 0 0 "java Hello failed"
    java -version 2>&1 | grep 'openjdk version "11'
    CHECK_RESULT $? 0 0 "java -version failed"

    mkdir testjava
    javac -g ./Hello.java -d testjava/
    CHECK_RESULT $? 0 0 "javac -g failed"
    find testjava -name Hello.class
    CHECK_RESULT $? 0 0 "not find Hello.class"
    javac -help 2>&1 | grep "用法: javac"
    CHECK_RESULT $? 0 0 "javac -hellp failed"
    javac -version 2>&1 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "javac -version failed"
    javac -version -nowarn 2>&1 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "javac -nowarn failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello* testjava
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
