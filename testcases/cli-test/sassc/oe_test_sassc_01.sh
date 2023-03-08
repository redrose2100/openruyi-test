#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangdaohong
# @Contact   :   3170809690@qq.com
# @Date      :   2023/02/21
# @License   :   Mulan PSL v2
# @Desc      :   Test sassc
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "sassc tar"
    tar -zxvf common/test.tar.gz
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    sassc --help | grep 'Usage:' 
    CHECK_RESULT $? 0 0 "Failed option: help"
    sassc -v | grep '[0-9]' 
    CHECK_RESULT $? 0 0 "Failed option: -v"
    cat test/tmp.css | sassc -s | grep 'width: auto; }' 
    CHECK_RESULT $? 0 0 "Failed option: -s"
    cat test/tmp.css | sassc -t compressed | grep 'body{width:auto}' 
    CHECK_RESULT $? 0 0 "Failed option: -t"
    cat test/tmp.css | sassc -l | grep '\/\* line' 
    CHECK_RESULT $? 0 0 "Failed option: -l"
    cat test/tmp.css | sassc -I test/ | grep ' width: auto; }' 
    CHECK_RESULT $? 0 0 "Failed option: -I"
    cat test/tmp.css | sassc -P test/ | grep ' width: auto; }' 
    CHECK_RESULT $? 0 0 "Failed option: -P"
    cat test/tmp.css | sassc -m inline | grep ' sourceMappingURL' 
    CHECK_RESULT $? 0 0 "Failed option: -m"
    cat test/tmp.css | sassc -p 1 | grep ' 32.4 px' 
    CHECK_RESULT $? 0 0 "Failed option: precision"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf test/
    LOG_INFO "End to restore the test environment."
}

main "$@"
