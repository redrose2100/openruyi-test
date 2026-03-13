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
# @Date      :   2026/03/13
# @License   :   Mulan PSL v2
# @Desc      :   Test gssproxy basic functions
# #############################################

source "$OET_PATH"/common/common_lib.sh

function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL gssproxy
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    test_execution gssproxy.service
    systemctl start gssproxy.service
    pgrep -f "gssproxy" > /dev/null
    CHECK_RESULT $? 0 0 "gssproxy service process not found after start"
    test -f /etc/gssproxy/gssproxy.conf
    CHECK_RESULT $? 0 0 "gssproxy configuration file not found"
    systemctl stop gssproxy.service
    systemctl status gssproxy.service | grep "inactive"
    CHECK_RESULT $? 0 0 "gssproxy.service stop failed"
    systemctl start gssproxy.service
    systemctl restart gssproxy.service
    systemctl status gssproxy.service | grep "Active: active"
    CHECK_RESULT $? 0 0 "gssproxy.service restart failed"
    systemctl enable gssproxy.service
    systemctl is-enabled gssproxy.service | grep "enabled"
    CHECK_RESULT $? 0 0 "gssproxy.service enable failed"
    
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    systemctl stop gssproxy.service
    systemctl disable gssproxy.service
    # shellcheck disable=SC2119
    DNF_REMOVE
    LOG_INFO "Finish environment cleanup!"
}

main "$@"

