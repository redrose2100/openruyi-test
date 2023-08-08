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
    custodia-cli mkdir --help | grep "usage: custodia-cli mkdir"
    CHECK_RESULT $? 0 0 "Check custodia-cli mkdir --help failed"
    custodia-cli rmdir -h | grep "usage: custodia-cli rmdir"
    CHECK_RESULT $? 0 0 "Check custodia-cli rmdir -h failed"
    custodia-cli rmdir --help | grep "usage: custodia-cli rmdir"
    CHECK_RESULT $? 0 0 "Check custodia-cli rmdir --help failed"
    custodia-cli ls -h | grep "usage: custodia-cli ls"
    CHECK_RESULT $? 0 0 "Check custodia-cli ls -h failed"
    custodia-cli ls --help | grep "usage: custodia-cli ls"
    CHECK_RESULT $? 0 0 "Check custodia-cli ls --help failed"
    custodia-cli get -h | grep "usage: custodia-cli get"
    CHECK_RESULT $? 0 0 "Check custodia-cli get -h failed"
    custodia-cli get --help | grep "usage: custodia-cli get"
    CHECK_RESULT $? 0 0 "Check custodia-cli get --help failed"
    custodia-cli set -h | grep "usage: custodia-cli set"
    CHECK_RESULT $? 0 0 "Check custodia-cli set -h failed"
    custodia-cli set --help | grep "usage: custodia-cli set"
    CHECK_RESULT $? 0 0 "Check custodia-cli set --help failed"
    custodia-cli del -h | grep "usage: custodia-cli del"
    CHECK_RESULT $? 0 0 "Check custodia-cli del -h failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"