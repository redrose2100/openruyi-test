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
# @Author    :   lihe
# @Contact   :   lihea@uniontech.com
# @Date      :   2024-05-21
# @License   :   Mulan PSL v2
# @Desc      :   test lastlog
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    lastlog
    CHECK_RESULT $? 0 0 "lastlog execute fail"
    lastlog --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "lastlog --help execute fail"
    lastlog -t 1
    CHECK_RESULT $? 0 0 "lastlog -t execute fail"
    lastlog -b 1
    CHECK_RESULT $? 0 0 "lastlog -b execute fail"
    login_name=$(whoami)
    lastlog -u "${login_name}" | grep "$(date +%d)" | grep "$(date +%Y)"
    CHECK_RESULT $? 0 0 "lastlog -u execute fail"
    lastlog -C -u "${login_name}"
    lastlog -u "${login_name}" | grep -E "从未|Never"
    CHECK_RESULT $? 0 0 "lastlog -C execute fail"
    lastlog -S -u "${login_name}"
    lastlog -u "${login_name}" | grep "$(date +%d)" | grep "$(date +%Y)"
    CHECK_RESULT $? 0 0 "lastlog -S execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
