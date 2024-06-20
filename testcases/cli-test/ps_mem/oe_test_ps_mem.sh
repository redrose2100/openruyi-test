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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-12-12
# @License   :   Mulan PSL v2
# @Desc      :   ps_mem basic function
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL firewalld
    systemctl restart firewalld
    pip3 install ps_mem
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ps_mem |grep Private |grep Shared |grep RAM |grep Program
    CHECK_RESULT $? 0 0 "Compilation failed"
    ps_mem -S |grep Swap
    CHECK_RESULT $? 0 0 "Compilation failed"
    pid=$(ps_mem -d |grep firewalld |awk -F[ '{print $2}' |awk -F] '{print $1}')
    ps_mem -p "$pid" |grep firewalld
    CHECK_RESULT $? 0 0 "Failed to view the memory usage of the specified process"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    pip3 uninstall ps_mem -y
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
