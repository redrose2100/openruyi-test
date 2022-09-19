#!/usr/bin/bash

# Copyright (c) 2022. Huawei Technologies Co.,Ltd.ALL rights reserved.
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
#@Date      :   2022/9/1
#@License   :   Mulan PSL v2
#@Desc      :   Test "linuxconsoletools" command
###################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment"
    DNF_INSTALL "linuxconsoletools"
    LOG_INFO "End to prepare the test environment"
}
function run_test() {
    LOG_INFO "Start to run testcase:oe_test_linuxconsoletools_ffcfstress."
    evdev-joystick --help 2>&1| grep -e "Usage:"
    CHECK_RESULT $? 0 0 "L$LINENO: --help, --h No Pass"
    LOG_INFO "End to run test."

}
function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main "$@"
