#!/usr/bin/bash

# Copyright (c) 2023. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   xiongneng
# @Contact   :   xiongneng@uniontech.com
# @Date      :   2023/06/02
# @License   :   Mulan PSL v2
# @Desc      :   Test auditctl-查看audit规则并验证规则
# #############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "audit"
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start testing..."
    service auditd start
    service auditd status |grep -i running
    CHECK_RESULT $? 0 0 "Service startup failed"
    auditctl -l |grep -i "No rules"
    CHECK_RESULT $? 0 0 "Existence rule"
    auditctl -w /etc/passwd -k password-file -p rwxa
    auditctl -l |grep passwd
    CHECK_RESULT $? 0 0 "No rules"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "Start to restore the tet environment."
    auditctl -D
    service auditd stop
    DNF_REMOVE "$@"
    LOG_INFO "Finish to restore the tet environment."
}

main "$@"