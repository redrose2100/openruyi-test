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
# @Date      :   2024-03-22
# @License   :   Mulan PSL v2
# @Desc      :   test hostid
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    hostid
    CHECK_RESULT $? 0 0 "hostid execute fail"
    hostid --help | grep -E "用法|Usage"
    CHECK_RESULT $? 0 0 "hostid --help execute fail"
    hostid --version | grep -i hostid
    CHECK_RESULT $? 0 0 "hostid --version execute fail"
    LOG_INFO "Finish test!"
}

main "$@"
