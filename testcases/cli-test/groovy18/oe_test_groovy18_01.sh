#!/usr/bin/bash

# Copyright (c) 2022. huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2022/08/26
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
    groovy18 -v | grep "Groovy Version"
    CHECK_RESULT $? 0 0 "Check groovy18 -v failed"
    groovy18 --version | grep "Groovy Version"
    CHECK_RESULT $? 0 0 "Check groovy18 --version failed"
    groovy18 --help | grep "usage: groovy"
    CHECK_RESULT $? 0 0 "Check groovy18 --help failed"
    groovy18 -h | grep "usage: groovy"
    CHECK_RESULT $? 0 0 "Check groovy18 -h failed"
    groovy18 -e 'println "Hello World!"' | grep "Hello World!"
    CHECK_RESULT $? 0 0 "Check groovy18 -e failed"
    groovy18 data/DataTypeTest.groovy  | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 file failed"
    groovy18 -cp lib/zipfs.jar data/DataTypeTest.groovy | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 -cp failed"
    groovy18 --classpath lib/zipfs.jar data/DataTypeTest.groovy | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 --classpath failed"
    groovy18 -l -e "println line.reverse()" > data.txt &
    SLEEP_WAIT 2
    grep "groovy is listening" data.txt
    CHECK_RESULT $? 0 0 "Check groovy18 -l failed"
    kill -9 $(pgrep -f "groovy18 -l -e")
    rm -f data.txt
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
