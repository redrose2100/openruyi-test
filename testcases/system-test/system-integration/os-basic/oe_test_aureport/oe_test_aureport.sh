#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   aliceye666
# @Contact   :   yezhifen@uniontech.com
# @Date      :   2023-3-27
# @License   :   Mulan PSL v2
# @Desc      :   Command aureport
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    aureport | grep "Summary Report"
    CHECK_RESULT $? 0 0 "aureport summary fail"
    aureport -a | grep "AVC Report"
    CHECK_RESULT $? 0 0 "aureport AVC fail"
    aureport -au | grep "Authentication Report"
    CHECK_RESULT $? 0 0 "aureport Authentication fail"
    aureport -e | grep "Event Report"
    CHECK_RESULT $? 0 0 "aureport Event fail"
    LOG_INFO "End to run test."
}

main "$@"
