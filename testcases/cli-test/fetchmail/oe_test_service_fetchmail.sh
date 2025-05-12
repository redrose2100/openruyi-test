#!/usr/bin/bash

# Copyright (c) 2024. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more detaitest -f.

# #############################################
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2024/7/2
# @License   :   Mulan PSL v2
# @Desc      :   Test fetchmail.service restart
# #############################################
#shellcheck disable=SC1091
source "${OET_PATH}/testcases/cli-test/common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL fetchmail
    echo "poll  pop.qq.com  protocol pop3 user 'QQ_NUMBER@qq.com' password 'YOUR_PASSEORD' sslproto ''" >>/etc/fetchmailrc.example
    chmod 600 /etc/fetchmailrc.example
    chown mail:mail /etc/fetchmailrc.example
    firewall-cmd --state|grep "not running"
    firewalld_status=$?
    systemctl stop firewalld
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    service=fetchmail.service
    systemctl restart "${service}"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} restart failed"
    systemctl stop "${service}"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep -E "Active: inactive|Active: failed"
    CHECK_RESULT $? 0 0 "${service} stop failed"
    systemctl start "${service}"
    CHECK_RESULT $? 0 0 "${service} start failed"
    SLEEP_WAIT 5
    systemctl status "${service}" | grep "Active: active"
    CHECK_RESULT $? 0 0 "${service} start failed"
    test_enabled "${service}"
    test_reload "${service}"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    systemctl stop fetchmail.service
    DNF_REMOVE "$@"
    if [ ${firewalld_status} -eq 1 ];then
        systemctl start firewalld
    fi
    LOG_INFO "End to restore the test environment."
}

main "$@"
