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
# @Date      :   2022/8/22
# @License   :   Mulan PSL v2
# @Desc      :   Test "criu" command
# ##################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test(){
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "criu"
    mkdir checkpoint_file
    LOG_INFO "End to prepare the test environment."
}

function run_test(){
    LOG_INFO "Start to run test."
    criu lazy-pages -D checkpoint_file &
    CHECK_RESULT $? 0 0
    kill -9 $(pgrep -f "criu lazy-pages")
    CHECK_RESULT $? 0 0 "Check --lazy-pages failed."
    criu cpuinfo dump
    CHECK_RESULT $? 0 0 "Check cpuinfo dump failed."
    criu cpuinfo check
    CHECK_RESULT $? 0 0 "Check cpuinfo check failed."
    criu -h | grep -E "Usage:"
    CHECK_RESULT $? 0 0 "Check -h failed."
    criu --help | grep -E "Usage:"
    CHECK_RESULT $? 0 0 "Check --help failed."
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf checkpoint_file cpuinfo.img
    LOG_INFO "End to restore the test environment."
}

main "$@"