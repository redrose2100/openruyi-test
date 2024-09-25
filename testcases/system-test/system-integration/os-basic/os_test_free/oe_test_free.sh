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
# @Author    :   suncui
# @Contact   :   suncui@uniontech.com
# @Date      :   2024-09-26
# @License   :   Mulan PSL v2
# @Desc      :   test free
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    free -b
    CHECK_RESULT $? 0 0 "free -b execute fail"
    free -k
    CHECK_RESULT $? 0 0 "free -k execute fail"
    free -m
    CHECK_RESULT $? 0 0 "free -m execute fail"
    free -g
    CHECK_RESULT $? 0 0 "free -g execute fail"
    free -h
    CHECK_RESULT $? 0 0 "free -h execute fail"
    free -l
    CHECK_RESULT $? 0 0 "free -l execute fail"
    free -t
    CHECK_RESULT $? 0 0 "free -t execute fail"

    LOG_INFO "Finish test!"
}

main "$@"
