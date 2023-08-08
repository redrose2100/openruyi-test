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
    custodia-cli del --help | grep "usage: custodia-cli del"
    CHECK_RESULT $? 0 0 "Check custodia-cli del --help failed"
    custodia-cli plugins -h | grep "usage: custodia-cli plugins"
    CHECK_RESULT $? 0 0 "Check custodia-cli plugins -h failed"
    custodia-cli plugins --help | grep "usage: custodia-cli plugins"
    CHECK_RESULT $? 0 0 "Check custodia-cli plugins --help failed"
    custodia --debug &
    custodia-cli --server /var/run/custodia/custodia.sock mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --server failed"
    custodia-cli --instance custodia mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --instance failed"
    custodia-cli --uds-urlpath /secrets/ mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --uds-urlpath failed"
    custodia-cli --verbose mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --verbose failed"
    custodia-cli --debug mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --debug failed"
    custodia-cli --timeout 10.0 mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --timeout failed"
    custodia-cli --cafile CAFILE mkdir test
    CHECK_RESULT $? 0 0 "Check custodia-cli --cafile failed"
    kill -9 $(pgrep -f "custodia --debug")
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"