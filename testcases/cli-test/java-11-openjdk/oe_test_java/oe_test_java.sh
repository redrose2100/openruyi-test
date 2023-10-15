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
# @Date      :   2023-07-11
# @License   :   Mulan PSL v2
# @Desc      :   Use java case
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environment preparation."
    DNF_INSTALL "java-11-openjdk java-11-openjdk-devel"
    pwd=$(pwd)
    mkdir java-11_test && cd java-11_test || exit
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    cat > Hello.java << EOF
public class Hello {
public static void main(String[] args) {
System.out.println("hello, world");
}
}
EOF
    CHECK_RESULT $? 0 0 "Fail to create Hello.java"
    javac Hello.java
    CHECK_RESULT $? 0 0 "Error,fail to create helloworld"
    java Hello | grep  "hello, world"
    CHECK_RESULT $? 0 0 "Error,check the 'Java' installation package or 'helloworld' file"

    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    cd "$pwd" && rm -rf java-11_test
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"