#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   shilei
#@Contact   	:   shilei1@xfusion.com
#@Date      	:   2023-05-25 20:30:43
#@License       :   Mulan PSL v2
#@Desc      	:   verification lsusb command
#####################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL usbutils
    LOG_INFO "End to prepare the test environment."
}
function run_test() {
    LOG_INFO "Start to run test."

        lsusb --help | grep "Show usage and help"
    CHECK_RESULT $? 0 0 "execute lsusb --help failure"

    lsusb -V | grep "lsusb (usbutils)"
    CHECK_RESULT $? 0 0 "execute lsusb -V failure"

    lsusb | grep -E "[0-9a-fA-F]{4}:[0-9a-fA-F]{4}"
    CHECK_RESULT $? 0 0 "execute lsusb failure"

    lsusb -v | grep -E "iManufacturer"
    CHECK_RESULT $? 0 0 "execute lsusb -v failure"

    lsusb -s 1 | grep -E "[0-9a-fA-F]{4}:[0-9a-fA-F]{4}"
    CHECK_RESULT $? 0 0 "execute lsusb -s 1 failure"

    tmp_id=`lsusb | awk '{print $6}' |head -n 1`
    lsusb -d $tmp_id | grep -E "[0-9a-fA-F]{4}:[0-9a-fA-F]{4}"
    CHECK_RESULT $? 0 0 "execute lsusb -d $tmp_id failure"

    lsusb -t | grep -E "\|__|/:"
    CHECK_RESULT $? 0 0 "execute lsusb -t failure"
    LOG_INFO "End to run test."
}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}
main "$@"