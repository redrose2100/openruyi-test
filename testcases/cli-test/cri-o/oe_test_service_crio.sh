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
# @Author    :   zhangpanting
# @Contact   :   1768492250@qq.com
# @Date      :   2023/05/04
# @License   :   Mulan PSL v2
# @Desc      :   Test crio.service restart
# #############################################
# shellcheck disable=SC1091
source "../common/common_lib.sh"

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL cri-o
    service=crio.service
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    test_execution ${service}
    systemctl start ${service}
    sed -i 's\ExecStart=/usr/bin/crio\ExecStart=/usr/bin/crio --log 10\g' /usr/lib/systemd/system/crio.service
    systemctl daemon-reload
    systemctl reload ${service}
    CHECK_RESULT $? 0 0 "crio.service reload failed"
    systemctl status ${service} | grep "Active: active"
    CHECK_RESULT $? 0 0 "crio.service reload causes the service status to change"
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    sed -i 's\ExecStart=/usr/bin/crio --log 10\ExecStart=/usr/bin/crio\g' /usr/lib/systemd/system/crio.service
    systemctl daemon-reload
    systemctl stop  ${service}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}


main "$@"
