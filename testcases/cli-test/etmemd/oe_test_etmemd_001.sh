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
# @Author    :   geyaning
# @Contact   :   geyaning@uniontech.com
# @Date      :   2023/03/06
# @License   :   Mulan PSL v2
# @Desc      :   etmem-任务启停
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "etmem"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    nohup etmemd -s etmemd_socket -l 0 &
    etmem obj add -f ${OET_PATH}/testcases/cli-test/etmemd/example_etmemd.yaml -s etmemd_socket
    CHECK_RESULT $? 0 0 "Failed to add project"
    etmem project show -s etmemd_socket | grep "project\: test"
    CHECK_RESULT $? 0 0 "Project query failure"
    etmem project start -n test -s etmemd_socket
    etmem project show -s etmemd_socket | grep "true"
    CHECK_RESULT $? 0 0 "Task start failure"
    etmem project stop -n test -s etmemd_socket
    etmem project show -s etmemd_socket | grep "false"
    CHECK_RESULT $? 0 0 "Task stop failure"
    etmem obj del -f ${OET_PATH}/testcases/cli-test/etmemd/example_etmemd.yaml -s etmemd_socket
    CHECK_RESULT $? 0 0 "Failed to del project"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
