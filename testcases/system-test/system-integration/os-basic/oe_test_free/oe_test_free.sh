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
# @Date      :   2024-04-10
# @License   :   Mulan PSL v2
# @Desc      :   system common command test-free
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    free --help 2>&1 | grep -i Usage
    CHECK_RESULT $? 0 0 "check free help fail"

    free -V 2>&1 | grep -i free
    CHECK_RESULT $? 0 0 "check free version fail"

    free 2>&1 | grep -i total
    CHECK_RESULT $? 0 0 "check free message fail"

    free -h 2>&1 | grep -i total
    CHECK_RESULT $? 0 0 "check free show human-readable output message fail"

    free -m 2>&1 | grep -i total
    CHECK_RESULT $? 0 0 "check ip show output in mebibytes message fail"

    free -k 2>&1 | grep -i total
    CHECK_RESULT $? 0 0 "check ip show output in kibibytes message fail"

    LOG_INFO "End to run test."
}

main "$@"