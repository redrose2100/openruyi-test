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
# @Date      :   2024-05-23
# @License   :   Mulan PSL v2
# @Desc      :   test jobs
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    jobs
    CHECK_RESULT $? 0 0 "jobs execute fail"
    jobs -l
    CHECK_RESULT $? 0 0 "jobs -l execute fail"
    top &
    process=$!
    CHECK_RESULT $? 0 0 "jobs top execute fail"
    jobs -l
    processe=$!
    CHECK_RESULT ${process} ${processe} 0 "job -l execute fail"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    kill -9 ${process}
    LOG_INFO "End to restore the test environment."
}

main "$@"