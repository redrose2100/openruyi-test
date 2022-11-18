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
# @Date      :   2022/9/18
# @License   :   Mulan PSL v2
# @Desc      :   Test "python-gitlab" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "python3-python-gitlab"
    echo -e "[global]
default = test
timeout = 5
ssh_verify = False

[test]
url = https://gitlab.com
private_token = glpat-gtfsnPBxt_DG16Jy5GbX
api_version = 4" > tmp.cfg
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    gitlab --version | grep "2.6.0"
    CHECK_RESULT $? 0 0 "Check gitlab --version failed"
    gitlab -c tmp.cfg user list | grep "id:"
    CHECK_RESULT $? 0 0 "Check gitlab -c CONFIG_FILE failed"
    gitlab --config-file tmp.cfg user list | grep "id:"
    CHECK_RESULT $? 0 0 "Check gitlab --config-file CONFIG_FILE failed"
    gitlab -v -c tmp.cfg user list | grep "id:"
    CHECK_RESULT $? 0 0 "Check gitlab -v failed"
    gitlab --verbose -c tmp.cfg user list | grep "id:"
    CHECK_RESULT $? 0 0 "Check gitlab --verbose failed"
    gitlab --fancy -c tmp.cfg user list | grep "id:"
    CHECK_RESULT $? 0 0 "Check gitlab --fancy failed"
    gitlab -d -c tmp.cfg user list | grep "send:"
    CHECK_RESULT $? 0 0 "Check gitlab -d failed"
    gitlab --debug -c tmp.cfg user list | grep "send:"
    CHECK_RESULT $? 0 0 "Check gitlab --debug failed"
    gitlab -g test -c tmp.cfg user list | grep "username:"
    CHECK_RESULT $? 0 0 "Check gitlab -g GITLAB failed"
    gitlab --gitlab test -c tmp.cfg user list | grep "username:"
    CHECK_RESULT $? 0 0 "Check gitlab --gitlab GITLAB failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf tmp.cfg
    LOG_INFO "End to restore the test environment."
}

main "$@"