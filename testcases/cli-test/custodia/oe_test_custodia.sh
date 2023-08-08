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
    touch custodia.conf
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    custodia -h | grep -E "usage: custodia \[-h\] \[--debug\] \[--instance INSTANCE\] \[configfile\]"
    CHECK_RESULT $? 0 0 "Check custodia -h failed"
    custodia --help | grep -E "usage: custodia \[-h\] \[--debug\] \[--instance INSTANCE\] \[configfile\]"
    CHECK_RESULT $? 0 0 "Check custodia --help failed"
    custodia --debug &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "custodia --debug")
    CHECK_RESULT $? 0 0 "Check custodia --debug failed"
    custodia --instance custodia &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "custodia --instance")
    CHECK_RESULT $? 0 0 "Check custodia --instance INSTANCE failed"
    custodia custodia.conf &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "custodia custodia.conf")
    CHECK_RESULT $? 0 0 "Check custodia configfile failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    rm -rf custodia.conf
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"