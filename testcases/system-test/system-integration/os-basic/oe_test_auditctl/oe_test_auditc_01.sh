#!/usr/bin/bash

# Copyright (c) 2023 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   zuohanxu
# @Contact   :   zuohanxu@uniontech.com
# @Date      :   2023.2.16
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-auditctl
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "audit"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    out_e0=$(auditctl -e 0 | grep 'enabled' | awk '{print $2}')
    CHECK_RESULT "$out_e0" 0 0 "auditctl -e 0 setting failure"
    out_s0=$(auditctl -s | grep 'enabled' | awk '{print $2}')
    CHECK_RESULT "$out_s0" 0 0 "auditctl -s display failure"
    out_e1=$(auditctl -e 1 | grep 'enabled' | awk '{print $2}')
    CHECK_RESULT "$out_e1" 1 0 "auditctl -e 1 setting failure"
    out_s1=$(auditctl -s | grep 'enabled' | awk '{print $2}')
    CHECK_RESULT "$out_s1" 1 0 "auditctl -s display failure"
    touch /tmp/test_auditctl
    autrace /bin/cat /tmp/test_auditctl | grep "Trace complete"
    CHECK_RESULT $? 0 0 "record generation failure"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    auditctl -e 0
    rm -rf /tmp/test_auditctl
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
