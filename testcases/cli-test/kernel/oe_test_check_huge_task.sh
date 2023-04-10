#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   chengweibin
# @Contact   :   chengweibin@uniontech.com
# @Date      :   2023-04-10
# @License   :   Mulan PSL v2
# @Desc      :   检查内核是否打开HUNG TASK相关开关
# ############################################
source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test()
{
    LOG_INFO "Start testing..."
    grep -w CONFIG_DETECT_HUNG_TASK=y /boot/config-`uname -r`
    CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK ERROR"

    grep -w CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120 /boot/config-`uname -r`
    CHECK_RESULT $? 0 0 "DETECT_HUNG_TASK_TIMEOUT ERROR"

    grep -w CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0 /boot/config-`uname -r`
    CHECK_RESULT $? 0 0 "BOOTPARAM_HUNG_TASK_PANIC_VALUE ERROR"
    LOG_INFO "Finish test!"
}

main $@
