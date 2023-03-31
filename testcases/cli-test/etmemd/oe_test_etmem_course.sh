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
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/03/31
# @License   :   Mulan PSL v2
# @Desc      :   etmem-启动服务端进程
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "etmem"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    etmemd -h |grep -i usage
    CHECK_RESULT $? 0 0 "Failed to view help information"
    nohup etmemd -s etmemd_socket -l 0 &
    ps -ef |grep etmemd_socket |grep -v grep
    CHECK_RESULT $? 0 0 "Process startup failed"
    nohup etmemd -s etmemd_socket_test -l 0 -m &
    ps -ef |grep etmemd_socket_test |grep -v grep
    CHECK_RESULT $? 0 0 "Process startup failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    ps -ef |grep etmemd_socket |grep -v grep |awk '{print $2}' |xargs -I {} kill -9 {}
    ps -ef |grep etmemd_socket_test |grep -v grep |awk '{print $2}' |xargs -I {} kill -9 {}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
