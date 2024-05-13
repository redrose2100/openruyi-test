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
# @Date      :   2023-08-02
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../common/Hello.java .
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    javac Hello.java
    pack200 -help | grep -iE "用法:|Usage"
    CHECK_RESULT $? 0 0 "pack200  -help failed"
    pack200 --version | grep "[0-9]"
    CHECK_RESULT $? 0 0 "pack200 --version failed"
    jar cvf Hello.jar Hello.class
    CHECK_RESULT $? 0 0 "jar cvf failed"
    find Hello.jar
    CHECK_RESULT $? 0 0 "not find Hello.jar"
    pack200 Hello.jar.pack.gz Hello.jar
    CHECK_RESULT $? 0 0 "pack200 Hello.jar.pack.gz failed"
    find Hello.jar.pack.gz
    CHECK_RESULT $? 0 0 "not find Hello.jar.pack.gz"
    rm -rf Hello.jar
    unpack200 Hello.jar.pack.gz Hello.jar
    CHECK_RESULT $? 0 0 "unpack200 failed"
    find Hello.jar
    CHECK_RESULT $? 0 0 "not find Hello.jar"
    rm -rf Hello.jar.pack.gz
    pack200 -q Hello.jar.pack.gz Hello.jar
    CHECK_RESULT $? 0 0 "pack -q failed"
    find Hello.jar.pack.gz
    CHECK_RESULT $? 0 0 "not find Hello.jar.pack.gz"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello.*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
