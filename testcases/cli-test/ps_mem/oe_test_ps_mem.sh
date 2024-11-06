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
# shellcheck disable=SC1090

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL ps_mem
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    ps_mem -h | grep -i "Usage:"
    CHECK_RESULT $? 0 0 "ps_mem -h failed"
    ps_mem -p 1 | grep -i "systemd"
    CHECK_RESULT $? 0 0 "ps_mem -p failed"
    ps_mem -s | grep -E "/usr/sbin/|/usr/sbin/"
    CHECK_RESULT $? 0 0 "ps_mem -s failed"
    ps_mem -t | grep -v "[0-9]"
    CHECK_RESULT $? 1 0 "ps_mem -t failed"
    nohup ps_mem -w 5 &
    CHECK_RESULT $? 0 0 "ps_mem -w failed"
    ps_mem | grep Private | grep Shared | grep RAM | grep Program
    CHECK_RESULT $? 0 0 "Compilation failed"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    rm -f nohup.out
    kill -9 "$(pgrep -f /usr/bin/ps_mem -w 5)"
    LOG_INFO "End to restore the test environment."
}

main "$@"
