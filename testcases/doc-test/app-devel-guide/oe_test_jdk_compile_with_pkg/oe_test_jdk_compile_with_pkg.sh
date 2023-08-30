#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   test_compile_gcc_create_use_libraries
# @Author    :   dingjiao
# @Contact   :   ding_jiao@hoperun.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   Compiling Java programs with packages using JDK
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment!"
    jdk_version=$(dnf search openjdk-devel | awk -F '-' 'NR==2{print $2}')
    jdk_name=java-$jdk_version-openjdk-devel.${NODE1_FRAME}
    DNF_INSTALL "$jdk_name"
    mkdir -p Test/my/example Hello/world/developers Hi/openos/openeuler
    cp ../common/Test.java Test/my/example/
    cp ../common/Hello.java Hello/world/developers/
    cp ../common/Hi.java Hi/openos/openeuler/
    LOG_INFO "End to prepare the test environment!"
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    javac -classpath Hello:Hi Test/my/example/Test.java
    CHECK_RESULT $? 0 0 "Javac compilation source file failed!"
    test -e Test/my/example/Test.class -a -e Hello/world/developers/Hello.class -a -e Hi/openos/openeuler/Hi.class
    CHECK_RESULT $? 0 0 "Class file does not exist!"
    java -classpath Test:Hello:Hi my/example/Test | grep "Hello, openEuler\|Hi, the global developers"
    CHECK_RESULT $? 0 0 "Java failed to execute Test program!"
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "Start environment cleanup."
    rm -rf ./Test ./Hello ./Hi
    DNF_REMOVE "$@"
    LOG_INFO "End environment cleanup."
}

main "$@"
