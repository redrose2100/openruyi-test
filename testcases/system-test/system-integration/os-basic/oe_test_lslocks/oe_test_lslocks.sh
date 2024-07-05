#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2024-7-4
# @License   :   Mulan PSL v2
# @Desc      :   command lslocks
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lslocks -h | grep -A 10 lslocks 
    CHECK_RESULT $? 0 0 "display help fail"
    lslocks -V | grep lslocks 
    CHECK_RESULT $? 0 0 "print version fail"
    lslocks | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "list information about all the currently held file locks fail"
    lslocks -b | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "print the sizes in bytes fail"
    lslocks -i | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "ignore lock files which are inaccessible for the current user fail"
    LOG_INFO "End to run test."
}

main "$@"
