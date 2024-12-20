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
# @Author    :   qinjiaxi
# @Contact   :   qinjiaxi@uniontech.com
# @Date      :   2024-08-23
# @License   :   Mulan PSL v2
# @Desc      :   test whoami
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    whoami
    CHECK_RESULT $? 0 0 "whoami execute fail"
    whoami --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "whoami --help execute fail"
    whoami --version | grep -i whoami
    CHECK_RESULT $? 0 0 "whoami --version execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
