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
# @Author    :   yuanrui
# @Contact   :   yuanrui@uniontech.com
# @Date      :   2024-06-11
# @License   :   Mulan PSL v2
# @Desc      :   test uptime
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    uptime
    CHECK_RESULT $? 0 0 "uptime execute fail"
    uptime --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "uptime --help execute fail"
    uptime --version | grep -i uptime
    CHECK_RESULT $? 0 0 "uptime --version execute fail"
    uptime | grep -oP 'load average: \K[\d.]+' | awk '{print $1}'
    CHECK_RESULT $? 0 0 "Check domain load average failed"
    uptime -s
    CHECK_RESULT $? 0 0 "uptime -s execute fail"
    LOG_INFO "Finish test!"
}
Check domain oad average failed
main "$@"