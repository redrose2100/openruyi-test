#!/usr/bin/bash

# Copyright (c) 2026. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   yangxi
# @Contact   :   1820463064@qq.com
# @Date      :   2026/04/21
# @License   :   Mulan PSL v2
# @Desc      :   Test haveged.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"


function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL haveged
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution haveged.service
    LOG_INFO "Test point 1: Test haveged.service enable/disable function."
    systemctl disable haveged.service
    CHECK_RESULT $? 0 0 "haveged.service disable failed"
    systemctl is-enabled haveged.service | grep "disabled"
    CHECK_RESULT $? 0 0 "haveged.service disable failed to change status to disabled"
    systemctl enable haveged.service
    CHECK_RESULT $? 0 0 "haveged.service enable failed"
    systemctl is-enabled haveged.service | grep "enabled"
    CHECK_RESULT $? 0 0 "haveged.service enable failed to change status to enabled"
    LOG_INFO "Test point 2: Test haveged command help information."
    haveged -h 2>&1 | grep -i "usage:"
    CHECK_RESULT $? 0 0 "haveged command help information query failed"
    LOG_INFO "Test point 3: Test haveged version information."
    haveged -V 2>&1 | grep -E "haveged|version"
    CHECK_RESULT $? 0 0 "haveged version information query failed"
    LOG_INFO "Test point 4: Test haveged.service status."
    systemctl status haveged.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "haveged.service is not active"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

