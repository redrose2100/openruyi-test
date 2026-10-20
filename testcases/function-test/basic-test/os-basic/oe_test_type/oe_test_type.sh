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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.12.05
# @License   :   Mulan PSL v2
# @Desc      :   type formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    type pwd | grep "shell"
    CHECK_RESULT $? 0 0 "type error"
    type -t pwd | grep "builtin"
    CHECK_RESULT $? 0 0 "type error"
    type -p sed | grep -E "/usr/bin/sed|/bin/sed"
    CHECK_RESULT $? 0 0 "type error"
    type -a echo | grep -E "/usr/bin/echo|/bin/echo"
    CHECK_RESULT $? 0 0 "type -a error"
    type -f ls | grep "ls"
    CHECK_RESULT $? 0 0 "type -f error"
    type -P cat | grep "/usr/bin/cat"
    CHECK_RESULT $? 0 0 "type -P error"    
    LOG_INFO "End to run test."
}

main "$@"
