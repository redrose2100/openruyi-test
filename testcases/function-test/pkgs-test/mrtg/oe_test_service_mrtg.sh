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
# @Desc      :   Test mrtg.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL mrtg
    log_time=$(date '+%Y-%m-%d %T')
    echo "RunAsDaemon: yes
NoDetach: yes" >>/etc/mrtg/mrtg.cfg
    sed -i 's\mrtg.ok\mrtg.ok --daemon\g' /usr/lib/systemd/system/mrtg.service
    systemctl daemon-reload
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    systemctl restart mrtg.service
    CHECK_RESULT $? 0 0 "mrtg.service restart failed"
    SLEEP_WAIT 5
    systemctl status mrtg.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "mrtg.service restart failed"
    systemctl start mrtg.service
    CHECK_RESULT $? 0 0 "mrtg.service start failed"
    SLEEP_WAIT 5
    systemctl status mrtg.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "mrtg.service start failed"
    test_enabled mrtg.service
    journalctl --since "${log_time}" -u mrtg.service | grep -i "fail\|error" | grep -v -i "DEBUG\|INFO\|WARNING" | grep -v "ERROR: Bailout after SIG TERM"
    CHECK_RESULT $? 0 1 "There is an error message for the log of mrtg.service"
    test_reload mrtg.service
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop mrtg.service
    DNF_REMOVE "$@"
    LOG_INFO "Finish to restore the test environment."
}

main "$@"
