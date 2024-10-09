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
# @Author    :   lihuan
# @Contact   :   lihuan@uniontech.com
# @Date      :   2024-10-19
# @License   :   Mulan PSL v2
# @Desc      :   test echo
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing echo command..."
    echo "hello & world" | grep "hello & world"
    CHECK_RESULT $? 0 0 "Echo with special characters failed"

    MY_VAR="test_variable"
    echo $MY_VAR | grep "test_variable"
    CHECK_RESULT $? 0 0 "Echo with environment variable failed"

    echo -e "line1\nline2" | grep -q "line2"
    CHECK_RESULT $? 0 0 "Echo with -e and escape sequences failed"
    LOG_INFO "Finish test!"
}

main "$@"