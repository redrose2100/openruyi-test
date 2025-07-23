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
# @Date      :   2024-06-12
# @License   :   Mulan PSL v2
# @Desc      :   test hostid
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    ipcs
    CHECK_RESULT $? 0 0 "ipcs execute fail"
    ipcs --version
    CHECK_RESULT $? 0 0 "ipcs --version execute fail"
    ipcs -m
    CHECK_RESULT $? 0 0 "ipcs -m execute fail"
    ipcs -l
    CHECK_RESULT $? 0 0 "ipcs -l execute fail"
    ipcs -a
    CHECK_RESULT $? 0 0 "ipcs -a execute fail"
    LOG_INFO "Finish test!"
}

main "$@"