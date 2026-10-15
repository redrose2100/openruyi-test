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
    criu check | grep 'Looks good'
    CHECK_RESULT $? 0 0 "Check criu check failed"
    criu check --experimental || criu check --experimental | grep "Looks good but some kernel features are missing" 
    CHECK_RESULT $? 0 0 "Check criu check --experimental failed"
    criu check --feature mnt_id | grep 'mnt_id is supported'
    CHECK_RESULT $? 0 0 "Check criu check --feature failed"
    criu check -o FILE
    CHECK_RESULT $? 0 0 "Check criu check -o failed"
    criu check --log-file FILE
    CHECK_RESULT $? 0 0 "Check criu check --log-file failed"
    criu check --log-pid
    CHECK_RESULT $? 0 0 "Check criu check --log-pid failed"
    criu check -v
    CHECK_RESULT $? 0 0 "Check criu check -v failed"
    criu check --verbosity
    CHECK_RESULT $? 0 0 "Check criu check --verbosity failed"
    criu check --config FILEPATH
    CHECK_RESULT $? 0 0 "Check criu check --config failed."
    criu check --no-default-config
    CHECK_RESULT $? 0 0 "Check criu check --no-default-config failed."
    LOG_INFO "End to run test."
}

function post_test(){
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -rf FILE
    LOG_INFO "End to restore the test environment."
}

main "$@"
