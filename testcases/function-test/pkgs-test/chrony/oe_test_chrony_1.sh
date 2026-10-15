#!/usr/bin/bash

# Copyright (c) 2025. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   libeibei
# @Contact   :   libeibei@uniontech.com
# @Date      :   2025/08/12
# @License   :   Mulan PSL v2
# @Desc      :   Test chronyd
# #############################################
#shellcheck disable=SC1091
source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the database config."
    DNF_INSTALL chrony
    LOG_INFO "End to prepare the database config."
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl start chronyd
    chronyc tracking | grep -q "Leap status"
    CHECK_RESULT $? 0 0 "chrony time synchronization not normal"
    chronyc sources | grep -q "address"
    CHECK_RESULT $? 0 0 "No active NTP server connection"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop chronyd
    DNF_REMOVE "$@"
    LOG_INFO "End to restore the test environment."
}

main "$@"
