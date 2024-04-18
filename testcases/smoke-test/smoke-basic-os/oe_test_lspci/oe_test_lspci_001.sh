#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   leepeng
# @Contact   :   lipeng2@uniontech.com
# @Date      :   2024-03-26
# @License   :   Mulan PSL v2
# @Desc      :   system common command test -lspci
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start testing..."
    lspci -v | grep bridge
    CHECK_RESULT $? 0 0 "Failed to query device info"
    lspci -k | grep Kernel
    CHECK_RESULT $? 0 0 "Failed to query Driver info"
    LOG_INFO "Finish test!"
}

main "$@"
