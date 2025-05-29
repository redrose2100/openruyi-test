#!/usr/bin/bash

# Copyright (c) 2025 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lufei
# @Contact   :   lufei@uniontech.com
# @Date      :   2025-04-15
# @License   :   Mulan PSL v2
# @Desc      :   test busctl
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    local bus
    bus="org.freedesktop.login1"

    busctl | grep $bus
    CHECK_RESULT $? 0 0 'busctl failed.'

    busctl status | grep "BusAddress"
    CHECK_RESULT $? 0 0 'busctl status failed.'

    busctl tree $bus | grep "└─/org"
    CHECK_RESULT $? 0 0 'busctl tree failed.'

    busctl tree -q | grep "└─/org"
    CHECK_RESULT $? 0 0 'busctl tree failed.'

}

main "$@"
