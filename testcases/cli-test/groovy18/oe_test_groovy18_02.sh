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
    grep -i ^groov ./data/words | groovy18 -p -e 'line.toUpperCase()' | grep GROOVE
    CHECK_RESULT $? 0 0 "Check groovy18 -p failed" 
    groovy18 -a -pe "split[0].toInteger()+split[-2].toInteger()" ./data/accounts.txt | grep "5"
    CHECK_RESULT $? 0 0 "Check groovy18 -a failed"
    find ./data -name "test*.groovy" | xargs groovy18 -i ./data/Script.groovy -pe '(line =~ "//.*").replaceAll("")'
    CHECK_RESULT $? 0 0 "Check groovy18 -i failed"
    rm -f ./data/*.bak
    grep -i ^groov ./data/words | groovy18 -n -e 'println line.toUpperCase()' | grep GROOVE
    CHECK_RESULT $? 0 0 "Check groovy18 -n failed"
    groovy18 --debug -e "throw new IOException()" > trace.data 2>&1
    grep IOException     trace.data
    CHECK_RESULT $? 0 0 "Check groovy18 --debug failed"
    rm -f trace.data
    groovy18 -d -e "throw new IOException()" > trace.data 2>&1
    grep IOException     trace.data
    CHECK_RESULT $? 0 0 "Check groovy18 -d failed"
    rm -f trace.data
    groovy18 -D message=world -e "println 'Hello, ' + System.getProperty('message')" | grep "Hello"
    CHECK_RESULT $? 0 0 "Check groovy18 -D failed"
    groovy18 --define message=world -e "println 'Hello, ' + System.getProperty('message')" | grep "Hello"
    CHECK_RESULT $? 0 0 "Check groovy18 --define failed"
    groovy18 --encoding UTF-8 ./data/DataTypeTest.groovy  | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 --encoding failed"
    groovy18 -cUTF-8 ./data/DataTypeTest.groovy  | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 -c failed"
    groovy18 --disableopt int ./data/DataTypeTest.groovy  | grep "name:张三"
    CHECK_RESULT $? 0 0 "Check groovy18 --disableopt failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
