#!/usr/bin/bash

# Copyright (c) 2024 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-04-03
# @License   :   Mulan PSL v2
# @Desc      :   test pidof
# ############################################

source "$OET_PATH"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start testing..."
    pidof
    CHECK_RESULT $? 0 1 "pidof execute fail"
    pidof --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "pidof --help execute fail"
    pidof --version | grep -i pidof
    CHECK_RESULT $? 0 0 "pidof --version execute fail"
    pidof bash -s | awk '{print NF}' | grep 1
    CHECK_RESULT $? 0 0 "pidof -s execute fail"
    # pid具有一定时效性顾不放在前置条件中生成文件
    pidof bash > /tmp/pid_bash_info
    pid_test_o=$(awk '{print $1}' /tmp/pid_bash_info)
    pidof bash -o "${pid_test_o}" | grep "${pid_test_o}"
    CHECK_RESULT $? 0 1 "pidof -o execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."

    rm -f /tmp/pid_bash_info

    LOG_INFO "End to restore the test environment."
}

main "$@"
