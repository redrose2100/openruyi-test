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
# @Author    :   mingyujing
# @Contact   :   mingyujing@uniontech.com
# @Date      :   2024-03-21
# @License   :   Mulan PSL v2
# @Desc      :   system common command test-ip
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    ip --help 2>&1 | grep -i usage
    CHECK_RESULT $? 0 0 "check ip help fail"

    ip -V 2>&1 | grep -i ip
    CHECK_RESULT $? 0 0 "check ip version fail"

    ip link show 2>&1 | grep -i link
    CHECK_RESULT $? 0 0 "check ip link fail"

    ip a 2>&1 | grep -i inet
    CHECK_RESULT $? 0 0 "check ip all message fail"

    ip route 2>&1 | grep -i default
    CHECK_RESULT $? 0 0 "check ip route fail"

    LOG_INFO "End to run test."
}

main "$@"

