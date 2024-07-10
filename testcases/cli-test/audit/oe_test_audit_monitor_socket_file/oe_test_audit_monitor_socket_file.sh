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
# @Author    :   lanyanling
# @Contact   :   lanyanling@uniontech.com
# @Date      :   2024-6-3
# @License   :   Mulan PSL v2
# @Desc      :   audit monitor socket file
# ############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    OLD_LANG=$LANG
    export LANG=en_US.UTF-8
    find /tmp -type f -name "somesocket" && rm -rf /tmp/somesocket
    service auditd restart
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    auditctl -w /tmp/somesocket -p rwxa -k "audit-socket"
    CHECK_RESULT $? 0 0 "Fail to set audit rule."
    python -c "import socket as s; sock = s.socket(s.AF_UNIX); sock.bind('/tmp/somesocket')"
    CHECK_RESULT $? 0 0 "Fail to create socket file."
    ausearch -f somesocket -k "audit-socket" | grep "/tmp/somesocket" | grep CREATE
    CHECK_RESULT $? 0 0 "Fail to audit socket file."
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    auditctl -D
    rm -rf /tmp/somesocket
    export LANG=${OLD_LANG}
    LOG_INFO "End to restore the test environment."
}
main "$@"
