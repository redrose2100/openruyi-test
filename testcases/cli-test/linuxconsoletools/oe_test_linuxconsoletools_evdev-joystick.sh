#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

###################################
#@Author    :   gaoyue
#@Contact   :   2829807379@qq.com
#@Date      :   2023/10/18
#@License   :   Mulan PSL v2
#@Desc      :   Test "linuxconsoletools" command
###################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "linuxconsoletools"
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run test."
    evdev-joystick --help 2>&1| grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: --help, --h No Pass"
    evdev-joystick --listdevs 2>&1
    CHECK_RESULT $? 0 0 "L$LINENO: --listdevs, --l No Pass"
    evdev-joystick --showcal /dev/input/event1 2>&1 | grep -e "Supported Absolute axes:"
    CHECK_RESULT $? 0 0 "L$LINENO: --showcal, --s [path] No Pass"
    evdev-joystick --evdev /dev/input/event1 2>&1 | grep -e "Event device file:"
    CHECK_RESULT $? 0 0 "L$LINENO: --evdev, --e [path] No Pass"
    evdev-joystick --e /dev/input/event1 --minimum 2 2>&1 | grep -e "New min value: 2"
    CHECK_RESULT $? 0 0 "L$LINENO: --minimum, --m [val] No Pass"
    evdev-joystick --e /dev/input/event1 --maximum 65536 2>&1 | grep -e "New max value: 65536"
    CHECK_RESULT $? 0 0 "L$LINENO: --maximum, --M [val] No Pass"
    evdev-joystick --e /dev/input/event1 --deadzone 0 2>&1 | grep -e "New dead zone value: 0"
    CHECK_RESULT $? 0 0 "L$LINENO: --deadzone, --d [val] No Pass"
    evdev-joystick --e /dev/input/event1 --fuzz 2 2>&1 | grep -e "New fuzz value: 2"
    CHECK_RESULT $? 0 0 "L$LINENO: --fuzz, --f [val] No Pass"
    evdev-joystick --e /dev/input/event1 --axis 0 2>&1 | grep -e "Axis index to deal with: 0"
    CHECK_RESULT $? 0 0 "L$LINENO: --axis, --a [val] No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
