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
# @Date      :   2024-7-5
# @License   :   Mulan PSL v2
# @Desc      :   command lslocks
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lslocks -J | grep command
    CHECK_RESULT $? 0 0 "use JSON output format fail"
    lslocks -n
    CHECK_RESULT $? 0 0 "do not print a header line fail"
    lslocks --output-all | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "output all available columns fail"
    lslocks -r | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "use the raw output format fail"
    lslocks -u | grep -A2 COMMAND
    CHECK_RESULT $? 0 0 "do not truncate text in columns fail"
    LOG_INFO "End to run test."
}

main "$@"
