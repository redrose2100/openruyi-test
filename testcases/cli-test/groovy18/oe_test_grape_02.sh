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
# @Author    :   朱文硕
# @Contact   :   1003254035@qq.com
# @Date      :   2023/03/21
# @License   :   Mulan PSL v2
# @Desc      :   Test grape
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
    grape18 -w install "com.gerardnico" "niofs-sftp" "1.0.0" | grep "WARNINGS"
    CHECK_RESULT $? 0 0 "Check grape -w failed"
    grape18 --warn install "com.gerardnico" "niofs-sftp" "1.0.0" | grep "WARNINGS"
    CHECK_RESULT $? 0 0 "Check grape --warn failed"
    grape18 --info install javax.servlet javax.servlet-api 3.0.1 | grep "SUCCESSFUL"
    CHECK_RESULT $? 0 0 "Check grape --info failed"
    grape18 uninstall javax.servlet javax.servlet-api 3.0.1
    grape18 -i install javax.servlet javax.servlet-api 3.0.1 | grep "SUCCESSFUL"
    CHECK_RESULT $? 0 0 "Check grape -i failed"
    grape18 uninstall javax.servlet javax.servlet-api 3.0.1
    grape18 -V install javax.servlet javax.servlet-api 3.0.1 | grep "Execution environment profile JavaSE"
    CHECK_RESULT $? 0 0 "Check grape -V failed"
    grape18 uninstall javax.servlet javax.servlet-api 3.0.1
    grape18 --verbose install javax.servlet javax.servlet-api 3.0.1 | grep "Execution environment profile JavaSE"
    CHECK_RESULT $? 0 0 "Check grape --verbose failed"
    grape18 uninstall javax.servlet javax.servlet-api 3.0.1
    grape18 -d install javax.servlet javax.servlet-api 3.0.1 | grep "circular dependency strategy"
    CHECK_RESULT $? 0 0 "Check grape -d failed"
    grape18 uninstall javax.servlet javax.servlet-api 3.0.1
    grape18 --debug install javax.servlet javax.servlet-api 3.0.1 | grep "circular dependency strategy"
    CHECK_RESULT $? 0 0 "Check grape --debug failed"
    grape18 -q install javax.servlet javax.servlet-api 3.0.1
    CHECK_RESULT $? 0 0 "Check grape -q failed"
    grape18 --quiet install javax.servlet javax.servlet-api 3.0.1
    CHECK_RESULT $? 0 0 "Check grape --quiet failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./data
    LOG_INFO "End to restore the test environment."
}

main "$@"
