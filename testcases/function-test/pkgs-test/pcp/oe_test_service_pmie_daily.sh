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
# @Author    :   liujingjing
# @Contact   :   liujingjing25812@163.com
# @Date      :   2025/6/6
# @License   :   Mulan PSL v2
# @Desc      :   Test pmie_daily.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL pcp
    service=pmie_daily.service
    log_time="$(date '+%Y-%m-%d %T')"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    systemctl restart "${service}" && systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    systemctl stop "${service}"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    systemctl start "${service}" && systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} start failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "${service} start failed"
    test_enabled "${service}"
    journalctl --since "${log_time}" -u "${service}" | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ${service}"
    systemctl start "${service}"
    SLEEP_WAIT 3
    systemctl reload "${service}" 2>&1 | grep "Job type reload is not applicable"
    CHECK_RESULT $? 0 0 "Job type reload is not applicable for unit ${service}"
    systemctl status "${service}" | grep "Active: inactive"
    CHECK_RESULT $? 0 0 "readonly-root.service reload causes the service status to change"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop pmie_daily.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
