#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   mingyujing
# @Contact   :   mingyujing@uniontech.com
# @Date      :   2024-03-21
# @License   :   Mulan PSL v2
# @Desc      :   system common command test-ip
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh


function run_test() {
    LOG_INFO "Start to run test."

    ip --help 2>&1 | grep -i usage
    CHECK_RESULT $? 0 0 "check ip help fail"

    ip -V
    CHECK_RESULT $? 0 0 "check ip version fail"

    ip link show
    CHECK_RESULT $? 0 0 "check ip link fail"

    ip a
    CHECK_RESULT $? 0 0 "check ip all message fail"

    ip route
    CHECK_RESULT $? 0 0 "check ip route fail"

    LOG_INFO "End to run test."
}

main "$@"

