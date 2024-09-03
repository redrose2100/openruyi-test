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
# @Author    :   huangcan
# @Contact   :   huangcan@uniontech.com
# @Date      :   2024-08-20
# @License   :   Mulan PSL v2
# @Desc      :   test disown
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    disown -a
    CHECK_RESULT $? 0 0 "disown -a execute fail"
    disown -r
    CHECK_RESULT $? 0 0 "disown -r execute fail"
    top > file.all 2>&1 & disown -h
    CHECK_RESULT $? 0 0 "disown execute fail"
    disown -h %1
    CHECK_RESULT $? 0 0 "disown execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -f file.all
    LOG_INFO "End to restore the test environment."
}

main "$@"