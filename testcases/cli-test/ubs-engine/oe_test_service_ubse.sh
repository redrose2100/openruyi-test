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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2026/06/26
# @License   :   Mulan PSL v2
# @Desc      :   Test ubse.service restart
# #############################################
# shellcheck disable=SC2119
source "${OET_PATH}"/testcases/cli-test/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL "ubs-engine audit-devel"
    service=ubse.service
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl restart ${service}
    CHECK_RESULT $? 0 0 "${service} restart failed"
    SLEEP_WAIT 5
    systemctl status ${service} | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    systemctl stop ${service}
    CHECK_RESULT $? 0 0 "${service} stop failed"
    SLEEP_WAIT 5
    systemctl status ${service} | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    systemctl start ${service}
    CHECK_RESULT $? 0 0 "${service} start failed"
    SLEEP_WAIT 5
    systemctl status ${service} | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} start failed"
    test_enabled ${service}
    journalctl --since "${log_time}" -u ${service} | grep -iE "fail|error|no such" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    test_reload ${service}
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
