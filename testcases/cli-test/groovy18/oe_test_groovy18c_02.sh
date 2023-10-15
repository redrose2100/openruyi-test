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
    groovy18c -d classes -cp ./lib/zipfs.jar ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c -cp failed"
    rm -rf classes
    groovy18c -d classes --sourcepath data/ ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c --sourcepath failed"
    rm -rf classes
    groovy18c --temp classes ./data/Script.groovy
    ls  | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c --temp failed"
    rm -f Script.class
    groovy18c -d classes -Jname=jack ./data/Script.groovy
    ls ./classes | grep Script.class
    CHECK_RESULT $? 0 0 "Check groovy18c -J failed"
    rm -rf classes
    groovy18c --baseScript ./classes/Script.class ./data/Person.groovy
    ls | grep Person.class
    CHECK_RESULT $? 0 0 "Check groovy18c --baseScript failed"
    rm -f Person.class
    groovy18c -b ./classes/Script.class ./data/Person.groovy
    ls | grep Person.class
    CHECK_RESULT $? 0 0 "Check groovy18c -b failed"
    rm -f Person.class
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
