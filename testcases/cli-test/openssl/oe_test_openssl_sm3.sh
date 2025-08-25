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
# @Author    :   tian8liang
# @Contact   :   tianliang@uniontech.com
# @Date      :   2024-3-29
# @License   :   Mulan PSL v2
# @Desc      :   Command openssl sm23
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    openssl speed -elapsed -evp sm3
    CHECK_RESULT $? 0 0 "openssl do not support sm3 encryption"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
