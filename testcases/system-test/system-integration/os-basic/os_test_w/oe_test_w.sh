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
# @Date      :   2024-09-27
# @License   :   Mulan PSL v2
# @Desc      :   test w
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    w -h
    CHECK_RESULT $? 0 0 "w -h execute fail"
    w -u
    CHECK_RESULT $? 0 0 "w -u execute fail"
    w -s
    CHECK_RESULT $? 0 0 "w -s execute fail"
    w -f
    CHECK_RESULT $? 0 0 "w -f execute fail"
    w -o
    CHECK_RESULT $? 0 0 "w -o execute fail"
    w -i
    CHECK_RESULT $? 0 0 "w -i execute fail"

    LOG_INFO "Finish test!"
}

main "$@"
