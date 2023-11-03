#!/usr/bin/bash

# Copyright (c) 2023. huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zhuwenshuo
# @Contact   :   1003254035@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test groovy
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "groovy18 tar"
    tar -xvf common/data.tar.gz > /dev/null
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    groovy18c --help | grep "usage: groovyc"
    CHECK_RESULT $? 0 0 "Check groovy18c --help failed"
    groovy18c -h | grep "usage: groovyc"
    CHECK_RESULT $? 0 0 "Check groovy18c -h failed"
    groovy18c -v  > gcversion.data 2>&1
    grep "Groovy compiler version" gcversion.data
    CHECK_RESULT $? 0 0 "Check groovy18c -v failed"
    rm -f gcversion.data
    groovy18c --version  > gcversion.data 2>&1
    grep "Groovy compiler version" gcversion.data
    CHECK_RESULT $? 0 0 "Check groovy18c --version failed"
    rm -f gcversion.data
    groovy18c -d classes ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c -d failed"
    rm -rf classes
    groovy18c -e ./data/ScriptException.groovy > trace.data 2>&1
    grep stacktrace trace.data
    CHECK_RESULT $? 0 0 "Check groovy18c -e failed"
    rm -f trace.data
    groovy18c --encoding UTF-8 -d classes ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c --encoding failed"
    rm -rf classes
    groovy18c -j ./data/Script.groovy ./data/TestDemo.java
    ls | grep TestDemo.class
    CHECK_RESULT $? 0 0 "Check groovy18c -j failed"
    rm -f TestDemo.class Script.class
    groovy18c -d classes -classpath ./lib/zipfs.jar ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c -classpath failed"
    rm -rf classes
    groovy18c -d classes --classpath ./lib/zipfs.jar ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c --classpath failed"
    rm -rf classes
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
