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
# @Date      :   2023-07-28
# @License   :   Mulan PSL v2
# @Desc      :   verification openjdk11 command
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk*"
    cp ../common/* .
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    javac Hello.java
    javap -help | grep -iE "用法:|Usage:"
    CHECK_RESULT $? 0 0 "javap -help failed"
    javap -version 2>&1 | grep "[0-9]"
    CHECK_RESULT $? 0 0 "javap -version failed"
    javap -public Hello | grep 'class Hello'
    CHECK_RESULT $? 0 0 "javap  public failed"
    javap -protected Hello | grep 'class Hello'
    CHECK_RESULT $? 0 0 "javap -protected failed"
    javap -package Hello | grep 'class Hello'
    CHECK_RESULT $? 0 0 "javap -package failed"
    javap -private Hello | grep 'class Hello'
    CHECK_RESULT $? 0 0 "javap -private failed"
    javap -p -v Hello | grep 'Classfile'
    CHECK_RESULT $? 0 0 "javap -p -v failed"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE "$@"
    rm -rf Hello*
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
