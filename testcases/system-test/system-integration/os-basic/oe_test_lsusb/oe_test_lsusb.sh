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
# @Author    :   wulei
# @Contact   :   wulei@uniontech.com
# @Date      :   2023-03-27
# @License   :   Mulan PSL v2
# @Desc      :   Command test lsusb
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL 'usbutils'
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    lsusb | grep 'Bus'
    CHECK_RESULT $? 0 0 "error displaying USB device information"
    lsusb -v | grep 'Device Descriptor'
    CHECK_RESULT $? 0 0 "detailed display of USB device information"
    find /dev/bus/usb/001/001
    CHECK_RESULT $? 0 0 "the linked device does not exist"
    lsusb -D /dev/bus/usb/001/001 | grep 'Device Descriptor'
    CHECK_RESULT $? 0 0 "detailed display of USB device information"
    lsusb -t | grep '/:'
    CHECK_RESULT $? 0 0 "display lsusb tree structure error"
    lsusb -V | grep 'usbutils'
    CHECK_RESULT $? 0 0 "error displaying lsusb version information"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
