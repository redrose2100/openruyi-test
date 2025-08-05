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
# @Author    :   yangyuangan
# @Contact   :   yangyuangan@uniontech.com
# @Date      :   2025.8.4
# @License   :   Mulan PSL v2
# @Desc      :   usb-devices formatting test
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function run_test() {
    LOG_INFO "Start to run test."
    usb-devices | grep Bus
    CHECK_RESULT $? 0 0 "usb-devices error"
    usb-devices | grep Ver
    CHECK_RESULT $? 0 0 "usb-devices error"
    usb-devices | grep Vendor
    CHECK_RESULT $? 0 0 "usb-devices error"
    usb-devices | grep Manufacturer
    CHECK_RESULT $? 0 0 "usb-devices error"
    usb-devices | grep Product
    CHECK_RESULT $? 0 0 "usb-devices error"
    usb-devices | grep SerialNumber
    CHECK_RESULT $? 0 0 "usb-devices error"
    LOG_INFO "End to run test."
}

main "$@"
