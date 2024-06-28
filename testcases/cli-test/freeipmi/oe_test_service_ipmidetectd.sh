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
# @Desc      :   Test ipmidetectd.service restart
# #############################################
# shellcheck disable=SC1091
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL freeipmi
    echo "ipmiping_period 15000
ipmidetectd_server_port 9225
host localhost.localdomain" >/etc/freeipmi/ipmidetectd.conf
    systemctl start bmc-watchdog.service
    systemctl start ipmiseld.service
    log_time=$(date '+%Y-%m-%d %T')
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart ipmidetectd.service
    CHECK_RESULT $? 0 0 "ipmidetectd.service restart failed"
    SLEEP_WAIT 5
    systemctl status ipmidetectd.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "ipmidetectd.service restart failed"
    systemctl start ipmidetectd.service
    CHECK_RESULT $? 0 0 "ipmidetectd.service start failed"
    SLEEP_WAIT 5
    systemctl status ipmidetectd.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "ipmidetectd.service start failed"
    journalctl --since "${log_time}" -u ipmidetectd.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING"
    CHECK_RESULT $? 0 1 "There is an error message for the log of ipmidetectd.service"
    test_reload ipmidetectd.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop bmc-watchdog.service
    systemctl stop ipmiseld.service
    systemctl stop ipmidetectd.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
