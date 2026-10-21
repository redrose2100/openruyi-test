#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2023/7/22
# @License   :   Mulan PSL v2
# @Desc      :   Test "criu" command
# ##################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "criu"
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    criu page-server & pid=$!
    CHECK_RESULT $? 0 0
    kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu page-server failed"
    criu page-server --address 127.0.0.1 & pid=$!
    CHECK_RESULT $? 0 0
    kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu page-server --address failed"
    criu page-server --port 114514 & pid=$!
    CHECK_RESULT $? 0 0
    kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu page-server --port failed"
    criu page-server -d
    CHECK_RESULT $? 0 0
    criu page-server --daemon
    CHECK_RESULT $? 0 0
    criu page-server --status-fd 0 & pid=$!
    CHECK_RESULT $? 0 0
    kill -9 $pid
    CHECK_RESULT $? 0 0 "Check criu page-server --status-fd failed"
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"