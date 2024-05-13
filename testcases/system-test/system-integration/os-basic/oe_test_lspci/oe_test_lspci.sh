#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
# @Date      :   2024-4-25
# @License   :   Mulan PSL v2
# @Desc      :   command lspci 
# ############################################
source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "start to run test."
    lspci | grep -i bridge
    CHECK_RESULT $? 0 0 "show pci device info fail"
    lspci -n | grep rev
    CHECK_RESULT $? 0 0 "show device manufacturer and device ID fail"
    lspci -v | grep -A3 -i bridge
    CHECK_RESULT $? 0 0 "show device driver info fail"
    lspci -k | grep -A3 -i bridge
    CHECK_RESULT $? 0 0 "show device driver module info fail"
    lspci -t
    CHECK_RESULT $? 0 0 "show device connection relationship info fail"
    lspci -vvv | grep -A3 -i bridge
    CHECK_RESULT $? 0 0 "show pci device detail info fail"
    LOG_INFO "End to run test."
}

main "$@"
