#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020-05-09
# @License   :   Mulan PSL v2
# @Desc      :   Command test-uname
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    uname -a | grep GNU
    CHECK_RESULT $? 0 0 "Execution failed"
    uname -m | grep -E "aarch64|x86_64|riscv64|ppc64le"
    CHECK_RESULT $? 0 0 "Execution failed"
    uname -n | grep "$(hostname)"
    CHECK_RESULT $? 0 0 "Execution failed"
    uname -r | grep -E "^[1-9]+\\.[0-9]+\\.[0-9]+"
    CHECK_RESULT $? 0 0 "Execution failed"
    LANG=C uname --help | grep "Usage"
    CHECK_RESULT $? 0 0 "Execution failed"
    uname -s | grep "Linux"
    CHECK_RESULT $? 0 0 "Execution failed"
    LOG_INFO "End to run test."
}

main "$@"
