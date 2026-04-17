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
# @Author    :   yangxi
# @Contact   :   1820463064@qq.com
# @Date      :   2026/04/13
# @License   :   Mulan PSL v2
# @Desc      :   Test haproxy.service restart
# #############################################

source "${OET_PATH}/libs/locallibs/common_lib.sh"

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL haproxy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution haproxy.service
    systemctl start haproxy.service
    systemctl disable haproxy.service
    CHECK_RESULT $? 0 0 "haproxy.service disable failed"
    systemctl is-enabled haproxy.service | grep "disabled"
    CHECK_RESULT $? 0 0 "haproxy.service disable failed to change status to disabled"
    systemctl enable haproxy.service
    CHECK_RESULT $? 0 0 "haproxy.service enable failed"
    systemctl is-enabled haproxy.service | grep "enabled"
    CHECK_RESULT $? 0 0 "haproxy.service enable failed to change status to enabled"
    haproxy -c -f /etc/haproxy/haproxy.cfg
    CHECK_RESULT $? 0 0 "haproxy configuration file syntax error"
    systemctl restart haproxy.service
    sleep 2
    journalctl -u haproxy.service --since "1 minute ago" | grep -E "Started|Starting|haproxy"
    CHECK_RESULT $? 0 0 "haproxy.service failed to record logs properly"
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    sed -i 's\ExecStart=/usr/sbin/haproxy -D\ExecStart=/usr/sbin/haproxy\g' /usr/lib/systemd/system/haproxy.service
    systemctl daemon-reload
    systemctl reload haproxy.service
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

