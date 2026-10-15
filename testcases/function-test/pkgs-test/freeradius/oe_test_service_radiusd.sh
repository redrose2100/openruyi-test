#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   huangrong
# @Contact   :   1820463064@qq.com
# @Date      :   2020/10/23
# @License   :   Mulan PSL v2
# @Desc      :   Test radiusd.service restart
# #############################################

source "${OET_PATH}/testcases/function-test/pkgs-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL freeradius
    log_time="$(date '+%Y-%m-%d %T')"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    DNF_INSTALL freeradius
    test_restart radiusd.service
    test_enabled radiusd.service
    journalctl --since "${log_time}" -u radiusd.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING\|my_auth_failover\|fail-over\|\"fail\"\|always fail\|softfail\|send_error"
    CHECK_RESULT $? 0 1 "There is an error message for the log of radiusd.service"
    systemctl start radiusd.service
    sed -i 's\ExecStart=/usr/sbin/radiusd\ExecStart=/usr/sbin/radiusd -P\g' /usr/lib/systemd/system/radiusd.service
    systemctl daemon-reload
    systemctl reload radiusd.service
    CHECK_RESULT $? 0 0 "radiusd.service reload failed"
    systemctl status radiusd.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "radiusd.service reload causes the service status to change"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i 's\ExecStart=/usr/sbin/radiusd -P\ExecStart=/usr/sbin/radiusd\g' /usr/lib/systemd/system/radiusd.service
    systemctl daemon-reload
    systemctl reload radiusd.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
