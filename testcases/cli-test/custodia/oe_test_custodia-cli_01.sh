#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# ##################################
# @Author    :   huangjiayi
# @Contact   :   1960887351@qq.com
# @Date      :   2022/8/21
# @License   :   Mulan PSL v2
# @Desc      :   Test "custodia" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "custodia"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    custodia-cli -h | grep "usage: custodia-cli"
    CHECK_RESULT $? 0 0 "Check custodia-cli -h failed"
    custodia-cli --help | grep "usage: custodia-cli"
    CHECK_RESULT $? 0 0 "Check custodia-cli --help failed"
    custodia --debug &
    custodia-cli mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli mkdir failed"
    custodia-cli ls test
    CHECK_RESULT $? 0 0 "Check custodia-cli ls failed"
    custodia-cli set test/name value
    CHECK_RESULT $? 0 0 "Check custodia-cli set failed"
    custodia-cli get test/name | grep "value"
    CHECK_RESULT $? 0 0 "Check custodia-cli get failed"
    custodia-cli del test/name
    CHECK_RESULT $? 0 0 "Check custodia-cli del failed"
    custodia-cli rmdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli rmdir failed"
    custodia-cli plugins | grep "custodia.authenticators"
    CHECK_RESULT $? 0 0 "Check custodia-cli plugins failed"
    custodia-cli mkdir -h | grep "usage: custodia-cli mkdir"
    CHECK_RESULT $? 0 0 "Check custodia-cli mkdir -h failed"
    kill -9 $(pgrep -f "custodia --debug")
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"